#!/usr/bin/env bash
# =============================================================================
# run.sh : dist/ déployé sur une base vide, comme en prod, puis tests utPLSQL,
# à partir de l'image de base de la CI (CI_DB_IMAGE, env/versions.env)
# up        : démarre la base (image préconstruite : APEX et utPLSQL installés)
# bootstrap : amorçage SYS commun au dev et à la prod (schémas, compte de
#             déploiement, Logger, droits, workspace APEX, ACL réseau), sans
#             le contrôle du credential (aucun secret en CI)
# deploy    : project gen-artifact puis project deploy, en proxy ; échec si un
#             changeset reste en attente ou si un objet est invalide
# test      : compile test/, lance utPLSQL ; rapport JUnit dans REPORT_DIR,
#             échec si un test échoue ou si aucun test ne s'exécute
# down      : supprime le conteneur et le secret
#
# Lancé par .github/workflows/ci.yml. Rejouable sur le poste, à côté du dev
# (noms et port distincts), après podman login ghcr.io.
#
# Usage : [REPORT_DIR=...] env/ci/run.sh up | bootstrap | deploy | test | down
# =============================================================================
set -euo pipefail

# Versions figées, partagées avec le dev : voir env/versions.env
# shellcheck source=SCRIPTDIR/../versions.env
source "$(dirname "${BASH_SOURCE[0]}")/../versions.env"
readonly CI_DB_IMAGE LOGGER_VERSION LOGGER_URL LOGGER_SHA256 \
  SQLCL_VERSION SQLCL_URL SQLCL_SHA256

# Noms distincts de ceux du dev et du build de l'image
readonly DB_CTR=jobtracker-ci-db
readonly DEPLOY_SECRET=jobtracker_ci_deploy_pwd
readonly PDB=FREEPDB1

# Cache des archives partagé avec le dev : un poste qui a déjà le dev ne
# retélécharge rien.
readonly CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/jobtracker"
readonly LOGGER_DIR="$CACHE_DIR/logger_$LOGGER_VERSION"
readonly SQLCL_DIR="$CACHE_DIR/sqlcl_$SQLCL_VERSION"
readonly LOG_DIR="$CACHE_DIR/logs"
readonly REPORT_DIR="${REPORT_DIR:-$CACHE_DIR/ci_reports}"
readonly CTR_BOOT_DIR=/tmp/jobtracker_ci_bootstrap
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
readonly REPO_DIR

# Arguments Liquibase de dist/install.sql, pour lb status
readonly LB_ARGS='-changelog-file releases/main.changelog.xml -search-path "." -def env/default.properties'

# ------------------------------------------------------------- utilitaires ---
info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31mERREUR :\033[0m %s\n' "$*" >&2; exit 1; }

# fetch_zip répertoire url sha256 : télécharge, vérifie l'empreinte, décompresse
fetch_zip() {
  local dir="$1" url="$2" sha="$3" tmp
  [[ -d "$dir" ]] && return
  info "Téléchargement de ${dir##*/}"
  mkdir -p "${dir%/*}"
  tmp="$(mktemp -d "${dir%/*}/.dl.XXXXXX")"
  curl -fsSL -o "$tmp/archive.zip" "$url"
  if ! printf '%s  %s\n' "$sha" "$tmp/archive.zip" | sha256sum -c --quiet - >/dev/null 2>&1; then
    rm -rf "$tmp"
    die "Empreinte SHA-256 inattendue pour $url"
  fi
  unzip -q "$tmp/archive.zip" -d "$tmp/content"
  mv "$tmp/content" "$dir"
  rm -rf "$tmp"
}

# sysdba : exécute en SYS, dans la PDB, le script SQL lu sur l'entrée
# standard. Authentification par l'OS du conteneur.
sysdba() {
  { printf 'whenever sqlerror exit failure\nset feedback off verify off\nconnect / as sysdba\nalter session set container = %s;\n' "$PDB"; cat; } \
    | podman exec -i "$DB_CTR" sqlplus -s -L /nolog
}

sysdba_value() {
  printf 'set heading off pagesize 0\n%s\n' "$1" | sysdba | tr -d '[:space:]'
}

secret_value() { podman secret inspect --showsecret --format '{{.SecretData}}' "$1"; }

running() { [[ "$(podman inspect -f '{{.State.Running}}' "$1" 2>/dev/null)" == "true" ]]; }

db_ready() { podman exec "$DB_CTR" /opt/oracle/checkDBStatus.sh; }

require_db() {
  if ! running "$DB_CTR" || ! db_ready >/dev/null 2>&1; then
    die "La base n'est pas prête : $0 up"
  fi
}

# Port de l'hôte attribué au hasard par Podman (aucun conflit avec le dev)
db_port() { podman port "$DB_CTR" 1521/tcp | head -1 | sed 's/.*://'; }

# wait_for "message" délai_max_secondes conteneur_surveillé commande...
# Sans terminal (CI), une ligne par minute au lieu d'un compteur réécrit.
wait_for() {
  local msg="$1" timeout="$2" ctr="$3" start elapsed
  shift 3
  start=$(date +%s)
  until "$@" >/dev/null 2>&1; do
    running "$ctr" || die "Le conteneur $ctr s'est arrêté. Voir : podman logs $ctr"
    elapsed=$(( $(date +%s) - start ))
    (( elapsed < timeout )) || die "$msg : délai dépassé. Voir : podman logs $ctr"
    (( elapsed % 60 < 10 )) && printf '  %s (écoulé : %ds)\n' "$msg" "$elapsed"
    sleep 10
  done
}

# SQLcl en proxy (jobtracker_deploy[jobtracker]), depuis la racine du dépôt,
# commandes lues sur l'entrée standard. Le CONNECT passe par le descripteur 3 :
# le mot de passe n'apparaît ni dans la ligne de commande ni sur disque.
sqlcl() {
  local java_major
  java_major="$(java -XshowSettings:properties -version 2>&1 | sed -n 's/^ *java.specification.version = //p')"
  [[ "${java_major:-0}" -ge 17 ]] 2>/dev/null || die "SQLcl demande Java 17 ou plus"
  fetch_zip "$SQLCL_DIR" "$SQLCL_URL" "$SQLCL_SHA256"
  (
    cd "$REPO_DIR"
    "$SQLCL_DIR/sqlcl/bin/sql" -S -L /nolog @/dev/fd/3 \
      3< <(printf 'connect jobtracker_deploy[jobtracker]/"%s"@//127.0.0.1:%s/%s\n' \
             "$(secret_value "$DEPLOY_SECRET")" "$(db_port)" "$PDB")
  )
}

# Objets invalides du schéma applicatif, avec leurs erreurs de compilation
check_invalid() {
  local invalid
  invalid="$(printf "set heading off feedback off pagesize 0
select count(*) from user_objects where status <> 'VALID';
exit\n" | sqlcl | tr -d '[:space:]')"
  [[ "$invalid" =~ ^[0-9]+$ ]] || die "Contrôle des objets invalides impossible : $invalid"
  (( invalid == 0 )) && return
  printf 'set linesize 200 pagesize 100
column name format a30
column text format a120
select name, type, line, text from user_errors order by name, type, sequence;
exit\n' | sqlcl >&2
  die "$invalid objets invalides dans JOBTRACKER"
}

# Le script de Logger s'exécute en tant que propriétaire : mot de passe jetable,
# jamais stocké, le temps de l'installation, puis retour à NO AUTHENTICATION.
install_logger() {
  local pwd rc=0
  pwd="Lg_$(openssl rand -hex 12)"
  sysdba <<<"alter user logger identified by \"$pwd\";"
  podman exec -i -w "$CTR_BOOT_DIR/logger" "$DB_CTR" sqlplus -s -L /nolog \
    >"$LOG_DIR/ci_logger_install.log" 2>&1 <<EOF || rc=$?
whenever sqlerror exit failure
connect logger/"$pwd"@//localhost:1521/$PDB
-- Le script contient un & dans un commentaire : sans cela, SQL*Plus
-- demanderait une valeur et consommerait la ligne suivante de l'entrée.
set define off
@logger_install.sql
exit
EOF
  sysdba <<<"alter user logger no authentication;"
  if (( rc != 0 )); then
    tail -n 30 "$LOG_DIR/ci_logger_install.log" >&2
    die "Installation de Logger en échec : voir $LOG_DIR/ci_logger_install.log"
  fi
}

# Compte de déploiement : mot de passe généré, masqué dans les journaux de
# GitHub Actions avant tout usage, transmis par l'entrée standard.
setup_deployer() {
  local pwd
  podman secret rm --ignore "$DEPLOY_SECRET" >/dev/null
  pwd="Dep_$(openssl rand -hex 12)"
  if [[ -n "${GITHUB_ACTIONS:-}" ]]; then echo "::add-mask::$pwd"; fi
  printf '%s' "$pwd" | podman secret create "$DEPLOY_SECRET" - >/dev/null
  sysdba <<<"@$CTR_BOOT_DIR/sql/common/create_deployer.sql"
  sysdba <<<"alter user jobtracker_deploy identified by \"$pwd\";"
}

# ------------------------------------------------------------- commandes ---
cmd_up() {
  command -v podman >/dev/null || die "Podman est absent : sudo dnf install podman"
  if podman container exists "$DB_CTR"; then
    die "Le conteneur $DB_CTR existe déjà : $0 down"
  fi
  info "Démarrage de la base ($CI_DB_IMAGE)"
  # --stop-timeout : comme en dev, laisse le temps au SHUTDOWN IMMEDIATE
  podman run -d --name "$DB_CTR" -p 127.0.0.1::1521 --stop-timeout 120 \
    "$CI_DB_IMAGE" >/dev/null
  wait_for "Base de données" 600 "$DB_CTR" db_ready
  info "Base prête : 127.0.0.1:$(db_port)/$PDB"
}

cmd_bootstrap() {
  require_db
  fetch_zip "$LOGGER_DIR" "$LOGGER_URL" "$LOGGER_SHA256"
  mkdir -p "$LOG_DIR"

  # podman cp crée les fichiers en root : nettoyage en root (-u 0)
  podman exec -u 0 "$DB_CTR" rm -rf "$CTR_BOOT_DIR"
  podman exec "$DB_CTR" mkdir -p "$CTR_BOOT_DIR"
  podman cp "$REPO_DIR/env/bootstrap" "$DB_CTR:$CTR_BOOT_DIR/sql"
  podman cp "$LOGGER_DIR" "$DB_CTR:$CTR_BOOT_DIR/logger"

  info "Création des schémas"
  sysdba <<<"@$CTR_BOOT_DIR/sql/common/create_schemas.sql USERS"

  info "Compte de déploiement (proxy vers JOBTRACKER)"
  setup_deployer

  info "Installation de Logger $LOGGER_VERSION"
  install_logger

  info "Droits, workspace APEX et ACL réseau"
  sysdba <<EOF
@$CTR_BOOT_DIR/sql/common/grants.sql
@$CTR_BOOT_DIR/sql/common/create_workspace.sql
@$CTR_BOOT_DIR/sql/common/network_acl.sql
EOF

  podman exec -u 0 "$DB_CTR" rm -rf "$CTR_BOOT_DIR"

  local invalid
  invalid="$(sysdba_value "select count(*) from dba_objects where owner in ('LOGGER', 'UT3') and status <> 'VALID';")"
  (( invalid == 0 )) || die "$invalid objets invalides dans LOGGER ou UT3"
  info "Amorçage terminé"
}

# Chemin de la prod : artefact tiré de dist/, joué par project deploy (qui
# exécute dist/install.sql). Les commandes project rendent 0 même en échec :
# leur effet est contrôlé (changesets en attente, objets invalides).
cmd_deploy() {
  require_db
  info "Génération et déploiement de l'artefact"
  printf 'whenever sqlerror exit failure
project gen-artifact -name jobtracker -version ci -force
project deploy -file artifact/jobtracker-ci.zip
exit\n' | sqlcl

  info "Changesets restant en attente (aucun attendu)"
  local status
  status="$(printf 'whenever sqlerror exit failure\ncd dist\nlb status %s\nexit\n' "$LB_ARGS" | sqlcl)" \
    || { printf '%s\n' "$status" >&2; die "lb status en échec"; }
  printf '%s\n' "$status"
  grep -q 'is up to date' <<<"$status" || die "Des changesets de dist/ n'ont pas été joués"

  info "Objets invalides (aucun attendu)"
  check_invalid
  info "Déploiement conforme"
}

# Tests compilés dans le schéma applicatif, comme en dev ; une erreur de
# compilation ne lève pas d'erreur SQL, d'où le contrôle des objets invalides.
# Rapport JUnit écrit par utPLSQL ; ses compteurs décident du résultat.
cmd_test() {
  require_db
  info "Compilation des packages de test"
  {
    echo 'whenever sqlerror exit failure'
    local f
    for f in "$REPO_DIR"/test/package_specs/*.sql "$REPO_DIR"/test/package_bodies/*.sql; do
      echo "@${f#"$REPO_DIR"/}"
    done
    echo exit
  } | sqlcl
  check_invalid

  info "Exécution des tests utPLSQL"
  mkdir -p "$REPORT_DIR"
  local report="$REPORT_DIR/junit.xml" script
  rm -f "$report"
  # Lancé en script : termout off n'agit pas sur les commandes de l'entrée standard
  script="$(mktemp --suffix .sql)"
  printf 'whenever sqlerror exit failure
set heading off feedback off pagesize 0 linesize 4000 trimspool on termout off
spool %s
select * from table(ut.run(ut_junit_reporter()));
spool off
exit\n' "$report" >"$script"
  printf '@%s\n' "$script" | sqlcl || { rm -f "$script"; die "Exécution d'utPLSQL en échec"; }
  rm -f "$script"

  local summary tests errors failures
  summary="$(grep -m1 -o '<testsuites [^>]*>' "$report")" || die "Rapport JUnit illisible : $report"
  tests="$(sed -n 's/.* tests="\([0-9]*\)".*/\1/p' <<<"$summary")"
  errors="$(sed -n 's/.* errors="\([0-9]*\)".*/\1/p' <<<"$summary")"
  failures="$(sed -n 's/.* failures="\([0-9]*\)".*/\1/p' <<<"$summary")"
  info "Tests : ${tests:-?}, échecs : ${failures:-?}, erreurs : ${errors:-?}"
  [[ "$tests" =~ ^[0-9]+$ && "$errors" =~ ^[0-9]+$ && "$failures" =~ ^[0-9]+$ ]] \
    || die "Compteurs absents du rapport JUnit : $summary"
  (( tests > 0 )) || die "Aucun test exécuté"
  if (( errors + failures > 0 )); then
    cat "$report" >&2
    die "Tests utPLSQL en échec"
  fi
  info "Tests réussis. Rapport : $report"
}

cmd_down() {
  podman rm -f --ignore "$DB_CTR" >/dev/null
  podman secret rm --ignore "$DEPLOY_SECRET" >/dev/null
  info "Conteneur $DB_CTR et secret $DEPLOY_SECRET supprimés"
}

case "${1:-}" in
  up)        cmd_up ;;
  bootstrap) cmd_bootstrap ;;
  deploy)    cmd_deploy ;;
  test)      cmd_test ;;
  down)      cmd_down ;;
  *)         echo "Usage : $0 up | bootstrap | deploy | test | down" >&2; exit 2 ;;
esac

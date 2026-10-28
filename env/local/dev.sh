#!/usr/bin/env bash
# =============================================================================
# dev.sh : environnement de dev local, dans un pod Podman rootless
#   - jobtracker-db   : Oracle Database Free (PDB FREEPDB1)
#   - jobtracker-ords : ORDS, qui installe APEX dans la base au premier démarrage
# bootstrap  : amorçage SYS (comptes, schémas, compte de déploiement, Logger,
#              utPLSQL, workspace APEX et son développeur, ACL réseau,
#              contrôle du credential de l'API), rejouable
# apex-admin : change le mot de passe ADMIN d'APEX (interactif)
# sql        : SQLcl (version figée) connecté en proxy au schéma applicatif,
#              depuis la racine du dépôt ; options SQLcl acceptées (-S...)
#
# Usage : env/local/dev.sh up | bootstrap | apex-admin | sql [options] | down | status | destroy
# =============================================================================
set -euo pipefail

# Versions figées : toute montée de version passe par un commit.
# APEX du dev <= APEX de la prod (Autonomous Database met APEX à jour seule),
# sinon un export du dev ne s'importe pas en prod.
readonly DB_IMAGE=container-registry.oracle.com/database/free:23.26.3.0
readonly ORDS_IMAGE=container-registry.oracle.com/database/ords:26.3.0
readonly APEX_VERSION=26.1

readonly POD=jobtracker
readonly DB_CTR=jobtracker-db
readonly ORDS_CTR=jobtracker-ords
readonly DB_VOLUME=jobtracker_oradata
readonly ORDS_VOLUME=jobtracker_ords_config
readonly SYS_SECRET=jobtracker_sys_pwd
readonly ORDS_SECRET=jobtracker_ords_pwd
readonly DEPLOY_SECRET=jobtracker_deploy_pwd
readonly APEX_DEV_SECRET=jobtracker_apex_dev_pwd
# Ports de l'hôte, surchargeables (HTTP_PORT=8081 env/local/dev.sh up).
# Lus uniquement à la création du pod : pour les changer, destroy puis up.
readonly DB_PORT="${DB_PORT:-1521}"
readonly HTTP_PORT="${HTTP_PORT:-8080}"
# PDB créée par l'image Free, nom non configurable
readonly PDB=FREEPDB1

# Fichiers d'installation d'APEX : hors du dépôt, montés en lecture seule dans ORDS
readonly APEX_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/jobtracker/apex_$APEX_VERSION"
readonly APEX_URL="https://download.oracle.com/otn_software/apex/apex_$APEX_VERSION.zip"

# Outils installés par l'amorçage, téléchargés hors du dépôt et vérifiés.
# Logger ne publie pas d'empreinte : celle-ci a été relevée au premier téléchargement.
readonly LOGGER_VERSION=3.1.1
readonly LOGGER_URL="https://raw.githubusercontent.com/OraOpenSource/Logger/$LOGGER_VERSION/releases/logger_$LOGGER_VERSION.zip"
readonly LOGGER_SHA256=8a83fa29a23ad7a038a46a4b0071523044d115dfc801ce5b55ac09deeb214969
readonly LOGGER_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/jobtracker/logger_$LOGGER_VERSION"
# Empreinte publiée par GitHub pour l'archive de la release (tag v.3.2.3)
readonly UTPLSQL_VERSION=3.2.3
readonly UTPLSQL_URL="https://github.com/utPLSQL/utPLSQL/releases/download/v.$UTPLSQL_VERSION/utPLSQL.zip"
readonly UTPLSQL_SHA256=6e650fc497bce02ae611e185e66c72204f0b984a024a41733b5452e7fb6db47a
readonly UTPLSQL_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/jobtracker/utplsql_$UTPLSQL_VERSION"
# Client de migration, lancé sur l'hôte (Java 17 ou plus). Oracle ne publie pas
# d'empreinte : celle-ci a été relevée au premier téléchargement.
readonly SQLCL_VERSION=26.3.0.260.1620
readonly SQLCL_URL="https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-$SQLCL_VERSION.zip"
readonly SQLCL_SHA256=eb0dca2becc30e9aa1c700ae71e5df6efde8a33d098d7d23405b6558bbb81a81
readonly SQLCL_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/jobtracker/sqlcl_$SQLCL_VERSION"

# Scripts d'amorçage du dépôt, copiés dans le conteneur le temps de l'amorçage
BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../bootstrap" && pwd)"
readonly BOOTSTRAP_DIR
readonly CTR_BOOT_DIR=/tmp/jobtracker_bootstrap
# Racine du dépôt : répertoire de travail de SQLcl Projects
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
readonly REPO_DIR
# Journaux d'installation de Logger et d'utPLSQL
readonly LOG_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/jobtracker/logs"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31mERREUR :\033[0m %s\n' "$*" >&2; exit 1; }

# ------------------------------------------------------------------ outils ---
# Règles du mot de passe SYS : acceptées par Oracle et sans caractère que
# SQL*Plus ou une chaîne de connexion interprète (@, /, ", espace...).
valid_pw() {
  # Expressions dans des variables : évite les pièges de quotage de =~
  local p="$1" re_up='[A-Z]' re_low='[a-z]' re_dig='[0-9]' re_spe='[_#.!-]' re_all='^[A-Za-z0-9_#.!-]+$'
  [[ ${#p} -ge 10 && $p =~ $re_up && $p =~ $re_low && $p =~ $re_dig && $p =~ $re_spe && $p =~ $re_all ]]
}

create_sys_secret() {
  local p1 p2
  echo "Mot de passe SYS : 10 caractères minimum, 1 majuscule, 1 minuscule, 1 chiffre,"
  echo "1 caractère spécial parmi _ # . ! -  (aucun autre symbole ni espace)."
  while true; do
    read -r -s -p "Mot de passe SYS : " p1; echo
    read -r -s -p "Confirmez : " p2; echo
    if [[ "$p1" != "$p2" ]]; then warn "Les deux saisies diffèrent."; continue; fi
    if ! valid_pw "$p1"; then warn "Mot de passe refusé : voir les règles ci-dessus."; continue; fi
    break
  done
  printf '%s' "$p1" | podman secret create "$SYS_SECRET" - >/dev/null
}

# Mot de passe d'ORDS_PUBLIC_USER : jamais utilisé à la main, donc généré
create_ords_secret() {
  printf 'Ords_%s' "$(openssl rand -hex 12)" | podman secret create "$ORDS_SECRET" - >/dev/null
}

# Mot de passe de JOBTRACKER_DEPLOY : lu par SQLcl, généré lui aussi
create_deploy_secret() {
  printf 'Dep_%s' "$(openssl rand -hex 12)" | podman secret create "$DEPLOY_SECRET" - >/dev/null
}

# Mot de passe du développeur APEX (DEV) : généré, relu pour se connecter au Builder
create_apex_dev_secret() {
  printf 'Dev_%s' "$(openssl rand -hex 12)" | podman secret create "$APEX_DEV_SECRET" - >/dev/null
}

secret_value() { podman secret inspect --showsecret --format '{{.SecretData}}' "$1"; }

fetch_apex() {
  [[ -f "$APEX_DIR/apxsilentins.sql" ]] && return
  info "Téléchargement d'APEX $APEX_VERSION (environ 330 Mo)"
  local tmp
  mkdir -p "${APEX_DIR%/*}"
  tmp="$(mktemp -d "${APEX_DIR%/*}/.apex.XXXXXX")"
  curl -fL --progress-bar -o "$tmp/apex.zip" "$APEX_URL"
  unzip -q "$tmp/apex.zip" -d "$tmp"
  mv "$tmp/apex" "$APEX_DIR"
  rm -rf "$tmp"
}

# fetch_zip répertoire url sha256 : télécharge, vérifie l'empreinte, décompresse
fetch_zip() {
  local dir="$1" url="$2" sha="$3" tmp
  [[ -d "$dir" ]] && return
  info "Téléchargement de ${dir##*/}"
  mkdir -p "${dir%/*}"
  tmp="$(mktemp -d "${dir%/*}/.dl.XXXXXX")"
  curl -fL --progress-bar -o "$tmp/archive.zip" "$url"
  if ! printf '%s  %s\n' "$sha" "$tmp/archive.zip" | sha256sum -c --quiet - >/dev/null 2>&1; then
    rm -rf "$tmp"
    die "Empreinte SHA-256 inattendue pour $url"
  fi
  unzip -q "$tmp/archive.zip" -d "$tmp/content"
  mv "$tmp/content" "$dir"
  rm -rf "$tmp"
}

# sysdba [répertoire_du_conteneur] : exécute en SYS, dans la PDB, le script SQL
# lu sur l'entrée standard, depuis le répertoire donné.
# Authentification par l'OS du conteneur : aucun mot de passe manipulé.
sysdba() {
  local workdir=()
  if [[ -n "${1:-}" ]]; then workdir=(-w "$1"); fi
  { printf 'whenever sqlerror exit failure\nset feedback off verify off\nconnect / as sysdba\nalter session set container = %s;\n' "$PDB"; cat; } \
    | podman exec -i "${workdir[@]}" "$DB_CTR" sqlplus -s -L /nolog
}

# Valeur d'une requête scalaire, sans mise en forme
sysdba_value() {
  printf 'set heading off pagesize 0\n%s\n' "$1" | sysdba | tr -d '[:space:]'
}

running() { [[ "$(podman inspect -f '{{.State.Running}}' "$1" 2>/dev/null)" == "true" ]]; }

port_free() { ! ss -ltnH "sport = :$1" | grep . >/dev/null; }

# Port de l'hôte réellement publié par le pod pour un port du conteneur
pod_port() { podman pod inspect "$POD" --format "{{(index (index .InfraConfig.PortBindings \"$1/tcp\") 0).HostPort}}"; }

# wait_for "message" délai_max_secondes conteneur_surveillé commande...
wait_for() {
  local msg="$1" timeout="$2" ctr="$3" start
  shift 3
  start=$(date +%s)
  until "$@" >/dev/null 2>&1; do
    running "$ctr" || die "Le conteneur $ctr s'est arrêté. Voir : podman logs $ctr"
    (( $(date +%s) - start < timeout )) || die "$msg : délai dépassé. Voir : podman logs $ctr"
    printf '\r  %s (écoulé : %ds)' "$msg" $(( $(date +%s) - start ))
    sleep 10
  done
  printf '\r\033[K'
}

db_ready()   { podman exec "$DB_CTR" /opt/oracle/checkDBStatus.sh; }
apex_ready() { curl -fs -o /dev/null "http://127.0.0.1:$1/ords/apex"; }

# ------------------------------------------------------------- commandes ---
cmd_up() {
  command -v podman >/dev/null || die "Podman est absent : sudo dnf install podman"

  if podman pod exists "$POD"; then
    info "Démarrage du pod $POD"
    podman pod start "$POD" >/dev/null
  else
    # Podman n'ouvre les ports qu'au démarrage : sans ce contrôle, un conflit
    # laisserait un pod créé mais impossible à démarrer.
    local port
    for port in "$DB_PORT" "$HTTP_PORT"; do
      port_free "$port" || die "Le port $port est déjà utilisé. Choisir un autre port : DB_PORT=... HTTP_PORT=... $0 up"
    done
    podman secret exists "$SYS_SECRET"  || create_sys_secret
    podman secret exists "$ORDS_SECRET" || create_ords_secret
    fetch_apex
    podman volume exists "$DB_VOLUME"   || podman volume create "$DB_VOLUME" >/dev/null
    podman volume exists "$ORDS_VOLUME" || podman volume create "$ORDS_VOLUME" >/dev/null

    info "Création du pod $POD (ports ouverts sur 127.0.0.1 uniquement)"
    # Dans un pod, les conteneurs partagent le réseau : ORDS joint la base sur localhost.
    podman pod create --name "$POD" \
      -p "127.0.0.1:$DB_PORT:1521" -p "127.0.0.1:$HTTP_PORT:8080" >/dev/null

    # La base ne lit le mot de passe que dans une variable d'environnement.
    # --stop-timeout : à l'arrêt, l'image fait un SHUTDOWN IMMEDIATE ; les 10 s
    # par défaut de Podman ne suffisent pas et finissent en SIGKILL (crash recovery).
    podman create --pod "$POD" --name "$DB_CTR" \
      --secret "$SYS_SECRET,type=env,target=ORACLE_PWD" \
      --stop-timeout 120 \
      -v "$DB_VOLUME:/opt/oracle/oradata" \
      "$DB_IMAGE" >/dev/null

    # ORDS lit les secrets montés dans /run/secrets/<NOM>.
    # :Z : étiquette SELinux propre au conteneur, sans quoi Fedora refuse l'accès.
    podman create --pod "$POD" --name "$ORDS_CTR" \
      --secret "$SYS_SECRET,target=ORACLE_PWD" \
      --secret "$ORDS_SECRET,target=ORACLE_USER_PWD" \
      -e DBHOST=localhost -e DBPORT=1521 -e DBSERVICENAME="$PDB" \
      -v "$ORDS_VOLUME:/etc/ords/config" \
      -v "$APEX_DIR:/opt/oracle/apex:ro,Z" \
      "$ORDS_IMAGE" >/dev/null

    podman start "$DB_CTR" >/dev/null
  fi

  # ORDS n'est lancé qu'une fois la base ouverte, pour ne pas épuiser ses tentatives
  # de connexion pendant la création de la base.
  info "Attente de la base (création au premier démarrage : plusieurs minutes)"
  wait_for "Base de données" 1800 "$DB_CTR" db_ready
  running "$ORDS_CTR" || podman start "$ORDS_CTR" >/dev/null
  info "Attente d'ORDS et d'APEX (installation au premier démarrage : 10 à 20 minutes)"
  wait_for "ORDS et APEX" 2400 "$ORDS_CTR" apex_ready "$(pod_port 8080)"

  cmd_status
}

# Le script de Logger s'exécute en tant que propriétaire : mot de passe jetable,
# jamais stocké, le temps de l'installation, puis retour à NO AUTHENTICATION
# même en cas d'échec.
install_logger() {
  local pwd rc=0
  pwd="Lg_$(openssl rand -hex 12)"
  sysdba <<<"alter user logger identified by \"$pwd\";"
  podman exec -i -w "$CTR_BOOT_DIR/logger" "$DB_CTR" sqlplus -s -L /nolog \
    >"$LOG_DIR/logger_install.log" 2>&1 <<EOF || rc=$?
whenever sqlerror exit failure
connect logger/"$pwd"@//localhost:1521/$PDB
-- Le script contient un & dans un commentaire : sans cela, SQL*Plus
-- demanderait une valeur et consommerait la ligne suivante de l'entrée.
set define off
@logger_install.sql
exit
EOF
  sysdba <<<"alter user logger no authentication;"
  (( rc == 0 )) || die "Installation de Logger en échec : voir $LOG_DIR/logger_install.log"
}

# Installation headless jouée en SYS : elle crée UT3 avec le mot de passe
# fourni, jetable lui aussi, puis UT3 passe en NO AUTHENTICATION.
# Lancée depuis source/ : les @@ imbriqués des composants en dépendent.
install_utplsql() {
  local pwd rc=0
  pwd="Ut_$(openssl rand -hex 12)"
  sysdba "$CTR_BOOT_DIR/utplsql" >"$LOG_DIR/utplsql_install.log" 2>&1 <<EOF || rc=$?
@install_headless.sql UT3 $pwd USERS
EOF
  if [[ "$(sysdba_value "select count(*) from dba_users where username = 'UT3';")" != 0 ]]; then
    sysdba <<<"alter user ut3 no authentication;"
  fi
  (( rc == 0 )) || die "Installation d'utPLSQL en échec : voir $LOG_DIR/utplsql_install.log"
}

# Compte de déploiement : le script commun le crée sans mot de passe, celui
# du secret est fixé ici. Le rejouer resynchronise la base avec le secret.
# Le mot de passe passe par l'entrée standard, jamais par la ligne de commande.
setup_deployer() {
  podman secret exists "$DEPLOY_SECRET" || create_deploy_secret
  sysdba <<<"@$CTR_BOOT_DIR/sql/common/create_deployer.sql"
  sysdba <<<"alter user jobtracker_deploy identified by \"$(secret_value "$DEPLOY_SECRET")\";"
}

# Connexion proxy de bout en bout, comme la fera SQLcl
check_deployer() {
  podman exec -i "$DB_CTR" sqlplus -s -L /nolog <<EOF
whenever sqlerror exit failure
set feedback off heading off
connect jobtracker_deploy[jobtracker]/"$(secret_value "$DEPLOY_SECRET")"@//localhost:1521/$PDB
select 'Proxy : ' || sys_context('userenv', 'proxy_user') || ' -> ' || user
  from dual;
exit
EOF
}

# Développeur du workspace (dev uniquement), administrateur du workspace.
# Supprimé puis recréé à chaque amorçage : son mot de passe suit le secret sans
# dépendre de l'ancien, que reset_password exige d'un appelant sans
# APEX_ADMINISTRATOR_ROLE. Les applications appartiennent au workspace, pas
# au développeur : elles ne sont pas touchées.
setup_apex_developer() {
  podman secret exists "$APEX_DEV_SECRET" || create_apex_dev_secret
  sysdba <<EOF
begin
   apex_util.set_workspace(p_workspace => 'JOBTRACKER');

   <<remove_developer>>
   for r_user in (
      select user_name
        from apex_workspace_apex_users
       where workspace_name = 'JOBTRACKER'
         and user_name = 'DEV'
   )
   loop
      apex_util.remove_user(p_user_name => r_user.user_name);
   end loop remove_developer;

   apex_util.create_user(
      p_user_name                    => 'DEV',
      p_web_password                 => '$(secret_value "$APEX_DEV_SECRET")',
      p_developer_privs              => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
      p_default_schema               => 'JOBTRACKER',
      p_change_password_on_first_use => 'N'
   );
end;
/
commit;
EOF
}

cmd_bootstrap() {
  if ! running "$DB_CTR" || ! db_ready >/dev/null 2>&1; then
    die "La base n'est pas prête : env/local/dev.sh up"
  fi
  fetch_zip "$LOGGER_DIR" "$LOGGER_URL" "$LOGGER_SHA256"
  fetch_zip "$UTPLSQL_DIR" "$UTPLSQL_URL" "$UTPLSQL_SHA256"
  mkdir -p "$LOG_DIR"

  # podman cp crée les fichiers en root : nettoyage en root (-u 0)
  info "Copie des scripts dans le conteneur $DB_CTR"
  podman exec -u 0 "$DB_CTR" rm -rf "$CTR_BOOT_DIR"
  podman exec "$DB_CTR" mkdir -p "$CTR_BOOT_DIR"
  podman cp "$BOOTSTRAP_DIR" "$DB_CTR:$CTR_BOOT_DIR/sql"
  podman cp "$LOGGER_DIR" "$DB_CTR:$CTR_BOOT_DIR/logger"
  podman cp "$UTPLSQL_DIR/utPLSQL/source" "$DB_CTR:$CTR_BOOT_DIR/utplsql"

  info "Verrouillage des comptes inutilisés et création des schémas"
  sysdba <<EOF
@$CTR_BOOT_DIR/sql/local/harden_apex.sql
@$CTR_BOOT_DIR/sql/common/create_schemas.sql USERS
EOF

  info "Compte de déploiement (proxy vers JOBTRACKER)"
  setup_deployer

  if [[ "$(sysdba_value "select count(*) from dba_objects where owner = 'LOGGER' and object_name = 'LOGGER' and object_type = 'PACKAGE';")" == 0 ]]; then
    info "Installation de Logger $LOGGER_VERSION"
    install_logger
  else
    info "Logger déjà installé"
  fi

  # Le paquet UT signe une installation complète ; UT3 sans UT, une installation
  # interrompue, que le script headless ne sait pas reprendre (CREATE USER).
  if [[ "$(sysdba_value "select count(*) from dba_objects where owner = 'UT3' and object_name = 'UT' and object_type = 'PACKAGE';")" != 0 ]]; then
    info "utPLSQL déjà installé"
  elif [[ "$(sysdba_value "select count(*) from dba_users where username = 'UT3';")" != 0 ]]; then
    die "UT3 existe sans utPLSQL (installation interrompue) : le supprimer (drop user ut3 cascade, en SYS dans $PDB), puis relancer"
  else
    info "Installation d'utPLSQL $UTPLSQL_VERSION"
    install_utplsql
  fi

  info "Droits du schéma applicatif"
  sysdba <<<"@$CTR_BOOT_DIR/sql/common/grants.sql"

  info "Workspace APEX JOBTRACKER et son développeur DEV"
  sysdba <<<"@$CTR_BOOT_DIR/sql/common/create_workspace.sql"
  setup_apex_developer

  info "ACL réseau vers l'API France Travail"
  sysdba <<<"@$CTR_BOOT_DIR/sql/common/network_acl.sql"

  # Créé à la main dans le Builder : absent au premier amorçage, d'où un
  # avertissement et non un arrêt
  info "Contrôle du credential de l'API France Travail"
  local credential_status
  credential_status="$(sysdba <<<"@$CTR_BOOT_DIR/sql/common/check_credential.sql" | tr -d '[:space:]')"

  podman exec -u 0 "$DB_CTR" rm -rf "$CTR_BOOT_DIR"

  local invalid
  invalid="$(sysdba_value "select count(*) from dba_objects where owner in ('LOGGER', 'UT3') and status <> 'VALID';")"
  (( invalid == 0 )) || die "$invalid objets invalides dans LOGGER ou UT3 : voir les journaux dans $LOG_DIR"

  sysdba <<'EOF'
set linesize 100 pagesize 50
column username format a22
column account_status format a16
column authentication_type format a14
select username, account_status, authentication_type
  from dba_users
 where username in ('JOBTRACKER', 'JOBTRACKER_DEPLOY', 'LOGGER', 'UT3', 'APEX_LISTENER', 'APEX_REST_PUBLIC_USER', 'PDBADMIN')
 order by username;
select 'Logger ' || logger.logger.get_pref('LOGGER_VERSION') as logger_version
  from dual;
-- Pas d'appel à ut.version() : UT est en droits de l'appelant, et SYS
-- n'accorde pas INHERIT PRIVILEGES (protection voulue, à ne pas lever).
column owner format a10
select owner, count(*) as objects
  from dba_objects
 where owner in ('LOGGER', 'UT3')
 group by owner
 order by owner;
column workspace_name format a14
column schema format a12
select workspace_name, schema
  from apex_workspace_schemas
 where workspace_name = 'JOBTRACKER';
column user_name format a10
column is_admin format a8
select workspace_name, user_name, is_admin
  from apex_workspace_apex_users
 where workspace_name = 'JOBTRACKER';
column host format a28
column principal format a12
column privilege format a10
select host, lower_port, upper_port, principal, privilege
  from dba_host_aces
 where host in ('entreprise.francetravail.fr', 'api.francetravail.io')
 order by host, principal;
EOF
  check_deployer || die "Connexion proxy jobtracker_deploy[jobtracker] en échec"
  info "Amorçage terminé. Builder : workspace JOBTRACKER, utilisateur DEV, mot de passe dans le secret $APEX_DEV_SECRET"
  info "Reste à changer le mot de passe ADMIN d'APEX : env/local/dev.sh apex-admin"
  case "$credential_status" in
    OK)        info "Credential FRANCE_TRAVAIL_API conforme (identifiants non contrôlés)" ;;
    ABSENT)    warn "Credential FRANCE_TRAVAIL_API absent : le créer dans le Builder (README, Identifiants de l'API France Travail)" ;;
    DIVERGENT) warn "Credential FRANCE_TRAVAIL_API différent des valeurs attendues (env/bootstrap/common/check_credential.sql) : le corriger dans le Builder" ;;
    *)         die "Contrôle du credential en échec : $credential_status" ;;
  esac
}

# Mot de passe ADMIN d'APEX, écrit en dur par l'image ORDS : apxchpwd.sql est
# interactif et écrit pour SQL*Plus (SQLcl rejette ses ACCEPT). Joué depuis la
# base, par l'authentification de l'OS, avec le seul fichier dont il dépend.
cmd_apex_admin() {
  if ! running "$DB_CTR" || ! db_ready >/dev/null 2>&1; then
    die "La base n'est pas prête : env/local/dev.sh up"
  fi
  local dir=/tmp/jobtracker_apxchpwd rc=0
  podman exec -u 0 "$DB_CTR" rm -rf "$dir"
  podman exec "$DB_CTR" mkdir -p "$dir/core/scripts"
  podman cp "$APEX_DIR/apxchpwd.sql" "$DB_CTR:$dir/"
  podman cp "$APEX_DIR/core/scripts/set_appun.sql" "$DB_CTR:$dir/core/scripts/"
  podman exec "$DB_CTR" bash -c "printf 'alter session set container = $PDB;\n@apxchpwd.sql\nexit\n' > $dir/run.sql"
  podman exec -it -w "$dir" "$DB_CTR" sqlplus -L / as sysdba @run.sql || rc=$?
  podman exec -u 0 "$DB_CTR" rm -rf "$dir"
  (( rc == 0 )) || die "apxchpwd.sql en échec"
}

# Session SQLcl en proxy (jobtracker_deploy[jobtracker]), depuis la racine du
# dépôt. Le CONNECT passe par un script lu sur le descripteur 3 : le mot de
# passe n'apparaît ni dans la ligne de commande ni sur disque, et l'entrée
# standard reste libre (session interactive, ou commandes passées par un pipe).
cmd_sql() {
  if ! running "$DB_CTR" || ! db_ready >/dev/null 2>&1; then
    die "La base n'est pas prête : env/local/dev.sh up"
  fi
  local java_major
  java_major="$(java -XshowSettings:properties -version 2>&1 | sed -n 's/^ *java.specification.version = //p')"
  [[ "${java_major:-0}" -ge 17 ]] 2>/dev/null || die "SQLcl demande Java 17 ou plus : sudo dnf install java-21-openjdk"
  fetch_zip "$SQLCL_DIR" "$SQLCL_URL" "$SQLCL_SHA256"
  cd "$REPO_DIR"
  exec "$SQLCL_DIR/sqlcl/bin/sql" "$@" -L /nolog @/dev/fd/3 \
    3< <(printf 'connect jobtracker_deploy[jobtracker]/"%s"@//localhost:%s/%s\n' \
           "$(secret_value "$DEPLOY_SECRET")" "$(pod_port 1521)" "$PDB")
}

cmd_down() {
  podman pod exists "$POD" || { info "Le pod $POD n'existe pas."; return; }
  info "Arrêt du pod $POD (base, configuration et secrets conservés)"
  podman pod stop "$POD" >/dev/null
}

cmd_status() {
  podman pod exists "$POD" || { info "Le pod $POD n'existe pas : env/local/dev.sh up"; return; }
  podman ps -a --filter "pod=$POD" --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}'
  local db_port http_port
  db_port="$(pod_port 1521)"
  http_port="$(pod_port 8080)"
  cat <<EOF

Base   : localhost:$db_port/$PDB   (sql sys@localhost:$db_port/$PDB as sysdba)
Déploiement : env/local/dev.sh sql   (jobtracker_deploy[jobtracker]@localhost:$db_port/$PDB, mot de passe : secret $DEPLOY_SECRET)
APEX   : http://localhost:$http_port/ords/apex   (workspace JOBTRACKER, utilisateur DEV, mot de passe : secret $APEX_DEV_SECRET)
SQL Developer Web : http://localhost:$http_port/ords/sql-developer
EOF
}

cmd_destroy() {
  if podman pod exists "$POD"; then
    info "Suppression du pod $POD et de ses conteneurs"
    podman pod rm -f "$POD" >/dev/null
  fi
  local answer
  read -r -p "Supprimer aussi les données (volumes) et les mots de passe (secrets) ? Saisir 'oui' : " answer
  if [[ "$answer" == "oui" ]]; then
    podman volume rm -f "$DB_VOLUME" "$ORDS_VOLUME" >/dev/null
    # --ignore : un secret absent (base amorcée avant le compte de déploiement)
    # n'empêche pas la suppression des autres
    podman secret rm --ignore "$SYS_SECRET" "$ORDS_SECRET" "$DEPLOY_SECRET" "$APEX_DEV_SECRET" >/dev/null 2>&1 || true
    info "Volumes et secrets supprimés. Fichiers APEX conservés dans $APEX_DIR"
  else
    info "Volumes et secrets conservés : le prochain 'up' retrouve la base."
  fi
}

case "${1:-}" in
  up)        cmd_up ;;
  bootstrap)  cmd_bootstrap ;;
  apex-admin) cmd_apex_admin ;;
  sql)        shift; cmd_sql "$@" ;;
  down)       cmd_down ;;
  status)     cmd_status ;;
  destroy)    cmd_destroy ;;
  *)          echo "Usage : $0 up | bootstrap | apex-admin | sql [options] | down | status | destroy" >&2; exit 2 ;;
esac

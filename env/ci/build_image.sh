#!/usr/bin/env bash
# =============================================================================
# build_image.sh : image de base de la CI, construite une fois et réutilisée
#   - Oracle Database Free : image du dev, base sans volume pour que
#     podman commit capture les datafiles
#   - APEX : installé par le conteneur ORDS au premier démarrage, comme en dev
#   - utPLSQL : installation headless, UT3 en NO AUTHENTICATION
# Logger et l'amorçage du projet restent hors de l'image : joués à chaque run
# de CI, ils restent testés.
# tag   : affiche le nom complet de l'image (versions et commit du dépôt)
# build : construit l'image en local, sans la publier (la publication est
#         faite par .github/workflows/ci-image.yml)
#
# Usage : [CI_IMAGE_REPO=ghcr.io/<owner>/jobtracker-ci-db] env/ci/build_image.sh tag | build
# =============================================================================
set -euo pipefail

# Versions figées, partagées avec le dev : voir env/versions.env
# shellcheck source=SCRIPTDIR/../versions.env
source "$(dirname "${BASH_SOURCE[0]}")/../versions.env"
readonly DB_IMAGE ORDS_IMAGE APEX_VERSION APEX_URL \
  UTPLSQL_VERSION UTPLSQL_URL UTPLSQL_SHA256

readonly IMAGE_REPO="${CI_IMAGE_REPO:-localhost/jobtracker-ci-db}"
readonly SOURCE_URL=https://github.com/NFleurentin/jobtracker

# Noms distincts de ceux du dev : un build peut tourner à côté du pod jobtracker
readonly POD=jobtracker-ci-build
readonly DB_CTR=jobtracker-ci-build-db
readonly ORDS_CTR=jobtracker-ci-build-ords
readonly SYS_SECRET=jobtracker_ci_build_sys_pwd
readonly ORDS_SECRET=jobtracker_ci_build_ords_pwd
# Image intermédiaire (commit du conteneur), supprimée après le squash
readonly COMMIT_IMAGE=localhost/jobtracker-ci-build:commit
readonly PDB=FREEPDB1

# Cache des archives partagé avec le dev : un poste qui a déjà le dev ne
# retélécharge rien.
readonly CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/jobtracker"
readonly APEX_DIR="$CACHE_DIR/apex_$APEX_VERSION"
readonly UTPLSQL_DIR="$CACHE_DIR/utplsql_$UTPLSQL_VERSION"
readonly LOG_DIR="$CACHE_DIR/logs"
readonly CTR_BOOT_DIR=/tmp/jobtracker_ci_build
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
readonly REPO_DIR

# ------------------------------------------------------------- utilitaires ---
info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31mERREUR :\033[0m %s\n' "$*" >&2; exit 1; }

# Tag immuable : versions des composants et commit du dépôt. Un arbre de
# travail modifié est signalé par -dirty : une telle image ne se publie pas.
image_tag() {
  local rev
  rev="$(git -C "$REPO_DIR" rev-parse --short=12 HEAD)"
  [[ -z "$(git -C "$REPO_DIR" status --porcelain)" ]] || rev+="-dirty"
  printf '%s:free%s-ords%s-apex%s-utplsql%s-%s\n' "$IMAGE_REPO" \
    "${DB_IMAGE##*:}" "${ORDS_IMAGE##*:}" "$APEX_VERSION" "$UTPLSQL_VERSION" "$rev"
}

fetch_apex() {
  [[ -f "$APEX_DIR/apxsilentins.sql" ]] && return
  info "Téléchargement d'APEX $APEX_VERSION (environ 330 Mo)"
  local tmp
  mkdir -p "${APEX_DIR%/*}"
  tmp="$(mktemp -d "${APEX_DIR%/*}/.apex.XXXXXX")"
  curl -fsSL -o "$tmp/apex.zip" "$APEX_URL"
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
  curl -fsSL -o "$tmp/archive.zip" "$url"
  if ! printf '%s  %s\n' "$sha" "$tmp/archive.zip" | sha256sum -c --quiet - >/dev/null 2>&1; then
    rm -rf "$tmp"
    die "Empreinte SHA-256 inattendue pour $url"
  fi
  unzip -q "$tmp/archive.zip" -d "$tmp/content"
  mv "$tmp/content" "$dir"
  rm -rf "$tmp"
}

# sysdba [répertoire_du_conteneur] : exécute en SYS, dans la PDB, le script SQL
# lu sur l'entrée standard. Authentification par l'OS du conteneur.
sysdba() {
  local workdir=()
  if [[ -n "${1:-}" ]]; then workdir=(-w "$1"); fi
  { printf 'whenever sqlerror exit failure\nset feedback off verify off\nconnect / as sysdba\nalter session set container = %s;\n' "$PDB"; cat; } \
    | podman exec -i "${workdir[@]}" "$DB_CTR" sqlplus -s -L /nolog
}

sysdba_value() {
  printf 'set heading off pagesize 0\n%s\n' "$1" | sysdba | tr -d '[:space:]'
}

running() { [[ "$(podman inspect -f '{{.State.Running}}' "$1" 2>/dev/null)" == "true" ]]; }

# wait_for "message" délai_max_secondes conteneur_surveillé commande...
# Sans terminal (CI), une ligne par minute au lieu d'un compteur réécrit.
wait_for() {
  local msg="$1" timeout="$2" ctr="$3" start elapsed
  shift 3
  start=$(date +%s)
  until "$@" >/dev/null 2>&1; do
    running "$ctr" || die "Le conteneur $ctr s'est arrêté"
    elapsed=$(( $(date +%s) - start ))
    (( elapsed < timeout )) || die "$msg : délai dépassé"
    (( elapsed % 60 < 10 )) && printf '  %s (écoulé : %ds)\n' "$msg" "$elapsed"
    sleep 10
  done
}

db_ready() { podman exec "$DB_CTR" /opt/oracle/checkDBStatus.sh; }

# Port de l'hôte attribué au hasard par Podman (aucun conflit avec le dev)
apex_ready() { curl -fs -o /dev/null "http://$(podman port "$DB_CTR" 8080/tcp | head -1)/ords/apex"; }

# En échec, les journaux des conteneurs sont affichés avant leur suppression.
cleanup() {
  local rc=$?
  if (( rc != 0 )); then
    local ctr
    for ctr in "$DB_CTR" "$ORDS_CTR"; do
      podman container exists "$ctr" || continue
      printf '\n----- podman logs %s (fin) -----\n' "$ctr" >&2
      podman logs --tail 50 "$ctr" >&2 || true
    done
  fi
  podman pod rm -f --ignore "$POD" >/dev/null 2>&1 || true
  podman secret rm --ignore "$SYS_SECRET" "$ORDS_SECRET" >/dev/null 2>&1 || true
  podman image rm --ignore "$COMMIT_IMAGE" >/dev/null 2>&1 || true
}

# Même installation que dev.sh : mot de passe UT3 jetable, puis NO AUTHENTICATION.
# Lancée depuis source/ : les @@ imbriqués des composants en dépendent.
install_utplsql() {
  local pwd rc=0
  pwd="Ut_$(openssl rand -hex 12)"
  sysdba "$CTR_BOOT_DIR/utplsql" >"$LOG_DIR/ci_utplsql_install.log" 2>&1 <<EOF || rc=$?
@install_headless.sql UT3 $pwd USERS
EOF
  if (( rc != 0 )); then
    tail -n 30 "$LOG_DIR/ci_utplsql_install.log" >&2
    die "Installation d'utPLSQL en échec : voir $LOG_DIR/ci_utplsql_install.log"
  fi
  sysdba <<<"alter user ut3 no authentication;"
}

# ------------------------------------------------------------- commandes ---
cmd_build() {
  command -v podman >/dev/null || die "Podman est absent : sudo dnf install podman"
  local tag ctx apex
  tag="$(image_tag)"
  info "Image : $tag"

  # Un build interrompu laisse pod, secrets et image intermédiaire : on repart de zéro.
  cleanup
  trap cleanup EXIT

  fetch_apex
  fetch_zip "$UTPLSQL_DIR" "$UTPLSQL_URL" "$UTPLSQL_SHA256"
  mkdir -p "$LOG_DIR"

  # Mots de passe jetables, jamais affichés
  printf 'Sys_%s' "$(openssl rand -hex 12)" | podman secret create "$SYS_SECRET" - >/dev/null
  printf 'Ords_%s' "$(openssl rand -hex 12)" | podman secret create "$ORDS_SECRET" - >/dev/null

  info "Création du pod $POD"
  podman pod create --name "$POD" -p 127.0.0.1::8080 >/dev/null
  # Aucun volume sur oradata : les datafiles restent dans la couche du
  # conteneur, que podman commit capture (l'image ne déclare pas de VOLUME).
  # Secret monté en fichier, lu par l'image dans /run/secrets/oracle_pwd : un
  # secret de type env serait repris par podman commit (contrôlé en fin de build).
  podman create --pod "$POD" --name "$DB_CTR" \
    --secret "$SYS_SECRET,target=oracle_pwd" \
    --stop-timeout 120 \
    "$DB_IMAGE" >/dev/null
  # Configuration d'ORDS sans volume : le conteneur est jeté après l'installation.
  podman create --pod "$POD" --name "$ORDS_CTR" \
    --secret "$SYS_SECRET,target=ORACLE_PWD" \
    --secret "$ORDS_SECRET,target=ORACLE_USER_PWD" \
    -e DBHOST=localhost -e DBPORT=1521 -e DBSERVICENAME="$PDB" \
    -v "$APEX_DIR:/opt/oracle/apex:ro,Z" \
    "$ORDS_IMAGE" >/dev/null

  podman start "$DB_CTR" >/dev/null
  info "Attente de la base"
  wait_for "Base de données" 1800 "$DB_CTR" db_ready
  podman start "$ORDS_CTR" >/dev/null
  info "Attente d'ORDS et d'APEX (installation : 10 à 20 minutes)"
  wait_for "ORDS et APEX" 2400 "$ORDS_CTR" apex_ready
  podman stop "$ORDS_CTR" >/dev/null

  apex="$(sysdba_value "select version || ':' || status from dba_registry where comp_id = 'APEX';")"
  [[ "$apex" == "$APEX_VERSION".*:VALID ]] || die "APEX inattendu dans la base : '$apex' (attendu : $APEX_VERSION, VALID)"
  info "APEX installé : $apex"

  info "Installation d'utPLSQL $UTPLSQL_VERSION"
  podman exec "$DB_CTR" mkdir -p "$CTR_BOOT_DIR"
  podman cp "$UTPLSQL_DIR/utPLSQL/source" "$DB_CTR:$CTR_BOOT_DIR/utplsql"
  install_utplsql
  # podman cp crée les fichiers en root : nettoyage en root (-u 0)
  podman exec -u 0 "$DB_CTR" rm -rf "$CTR_BOOT_DIR"

  # SHUTDOWN IMMEDIATE explicite, sans délai : celui de l'image, lancé par
  # podman stop, dépasse les 120 s après l'installation d'APEX et finit en
  # SIGKILL. Datafiles cohérents, sans crash recovery au démarrage de la CI.
  info "Arrêt de la base et commit du conteneur"
  printf 'whenever sqlerror exit failure\nconnect / as sysdba\nshutdown immediate\n' \
    | podman exec -i "$DB_CTR" sqlplus -s -L /nolog >/dev/null
  podman stop "$DB_CTR" >/dev/null
  podman commit --quiet "$DB_CTR" "$COMMIT_IMAGE" >/dev/null
  # Libère la couche du conteneur avant le squash (pic d'espace disque)
  podman pod rm -f "$POD" >/dev/null

  # Les datafiles modifiés sont recopiés en entier dans la couche du commit :
  # le squash en une couche retire les 4 Go de datafiles de l'image de base.
  info "Squash de l'image en une couche"
  ctx="$(mktemp -d)"
  printf 'FROM %s\n' "$COMMIT_IMAGE" | podman build --quiet --squash-all --pull=never \
    --label "org.opencontainers.image.source=$SOURCE_URL" \
    --label "org.opencontainers.image.revision=$(git -C "$REPO_DIR" rev-parse HEAD)" \
    --label "org.opencontainers.image.description=Base de CI de jobtracker : Oracle Database Free, APEX $APEX_VERSION, utPLSQL $UTPLSQL_VERSION" \
    -t "$tag" -f - "$ctx" >/dev/null
  rmdir "$ctx"

  # L'image de base déclare ORACLE_PWD vide : seule une valeur est une fuite.
  if podman image inspect --format '{{range .Config.Env}}{{println .}}{{end}}' "$tag" | grep -q '^ORACLE_PWD=.'; then
    podman image rm "$tag" >/dev/null
    die "ORACLE_PWD renseigné dans la configuration de l'image : image supprimée"
  fi

  info "Image construite : $tag ($(podman image inspect --format '{{.Size}}' "$tag" | numfmt --to=iec) décompressée)"
}

case "${1:-}" in
  tag)   image_tag ;;
  build) cmd_build ;;
  *)     echo "Usage : $0 tag | build" >&2; exit 2 ;;
esac

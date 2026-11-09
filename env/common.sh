# shellcheck shell=bash
# =============================================================================
# common.sh : contrôles du schéma applicatif communs au dev (env/local/dev.sh)
# et à la CI (env/ci/run.sh), pour qu'ils ne divergent pas.
#
# Sourcé, jamais exécuté. Le script appelant définit :
#   - sqlcl    : SQLcl connecté en proxy au schéma applicatif, silencieux (-S),
#                lancé depuis la racine du dépôt, commandes lues sur l'entrée
#                standard ;
#   - die      : message d'erreur et sortie en échec ;
#   - REPO_DIR : racine du dépôt.
# =============================================================================

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

# Packages de test de test/ compilés dans le schéma applicatif, specs puis
# bodies. Une erreur de compilation PL/SQL ne lève pas d'erreur SQL : le
# contrôle des objets invalides la détecte.
compile_tests() {
  {
    echo 'whenever sqlerror exit failure'
    local f
    for f in "$REPO_DIR"/test/package_specs/*.sql "$REPO_DIR"/test/package_bodies/*.sql; do
      echo "@${f#"$REPO_DIR"/}"
    done
    echo exit
  } | sqlcl
  check_invalid
}

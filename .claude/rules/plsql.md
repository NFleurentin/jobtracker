---
paths:
  - "**/*.sql"
  - "**/*.pks"
  - "**/*.pkb"
---

# Règles PL/SQL

Ces règles couvrent les packages, les jobs et les tests utPLSQL. Le schéma et les migrations sont dans `sql.md`.

## Référence

Trivadis PL/SQL & SQL Coding Guidelines. Préfixes : `l_` local, `g_` global, `co_` constante, `in_`, `out_`, `io_` paramètre selon son mode, `c_` curseur, `p_` paramètre de curseur, `r_` record, `t_` type (avec le suffixe `_type`), `e_` exception. Seuls les choix propres au dépôt figurent ici.

## Packages

- Toute la logique est dans des packages : ni procédure ou fonction autonome, ni logique métier dans un trigger.
- La spec est le contrat public : une modification incompatible impose le `!` du commit (`git.md`).
- `COMMIT` et `ROLLBACK` uniquement dans les points d'entrée appelés par `DBMS_SCHEDULER`, jamais dans les procédures de service. Le code appelé par APEX n'en fait pas : APEX valide la transaction en fin de traitement.

## Erreurs et journalisation

- Journalisation avec Logger (OraOpenSource). Pas de `DBMS_OUTPUT` dans le code livré.
- Pas de `WHEN OTHERS` sans journalisation et relance.
- Codes `RAISE_APPLICATION_ERROR` attribués par plage, une plage par package, déclarée en constantes dans sa spec.

## Collecte

- Appels HTTP par `APEX_WEB_SERVICE`, uniquement dans les packages de collecte.
- Les identifiants de l'API sont référencés par le nom d'un credential, jamais écrits dans le code.
- Un job `DBMS_SCHEDULER` s'exécute hors session APEX : établir le contexte du workspace (`APEX_SESSION.CREATE_SESSION`) avant d'utiliser un Web Credential APEX.

## Tests

Chaque package public a son package de test utPLSQL `test_<package>`.

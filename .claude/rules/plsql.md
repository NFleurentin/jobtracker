---
paths:
  - "**/*.sql"
  - "**/*.pks"
  - "**/*.pkb"
---

# Règles PL/SQL

Ces règles couvrent les packages, les jobs et les tests utPLSQL. Le schéma et les migrations sont dans `sql.md`.

## Référence

Trivadis PL/SQL & SQL Coding Guidelines (préfixes `l_`, `g_`, `p_`, `c_`, `r_`, `t_`). Seuls les choix propres au dépôt figurent ici.

## Packages

- Toute la logique est dans des packages : ni procédure ou fonction autonome, ni logique métier dans un trigger.
- La spec est le contrat public : une modification incompatible impose le `!` du commit (`git.md`).
- `COMMIT` et `ROLLBACK` uniquement dans les points d'entrée appelés par `DBMS_SCHEDULER` ou par APEX, jamais dans les procédures de service.

## Erreurs et journalisation

- Journalisation avec Logger (OraOpenSource). Pas de `DBMS_OUTPUT` dans le code livré.
- Pas de `WHEN OTHERS` sans journalisation et relance.
- Codes `RAISE_APPLICATION_ERROR` attribués par plage, une plage par package, déclarée en constantes dans sa spec.

## Collecte

- Appels HTTP par `APEX_WEB_SERVICE`, uniquement dans les packages de collecte.
- Les identifiants de l'API sont référencés par le nom d'un credential, jamais écrits dans le code.

## Tests

Chaque package public a son package de test utPLSQL `test_<package>`.

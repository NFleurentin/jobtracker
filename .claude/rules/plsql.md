---
paths:
  - "**/package_specs/**"
  - "**/package_bodies/**"
  - "**/triggers/**"
  - "**/type_specs/**"
  - "**/type_bodies/**"
  - "test/**"
---

# Règles PL/SQL

Ces règles couvrent les packages, les jobs et les tests utPLSQL. Le schéma et les migrations sont dans `sql.md`.

## Référence

Trivadis PL/SQL & SQL Coding Guidelines. Préfixes : `l_` local, `g_` global, `co_` constante, `in_`, `out_`, `io_` paramètre selon son mode, `c_` curseur, `p_` paramètre de curseur, `r_` record, `t_` type (avec le suffixe `_type`), `e_` exception. Seuls les choix propres au dépôt figurent ici.

## Style

- Style imposé par le formateur du projet (`.dbtools/project.sqlformat.xml`), qu'applique `project export` : écrire en 4 espaces, commentaires alignés sur le code (le formateur ne les déplace pas). `test/`, hors export, se formate avec les mêmes règles (`format rules .dbtools/project.sqlformat.xml`, puis `format file`).
- Pas d'esperluette littérale dans le source, commentaires compris : SQL*Plus et SQLcl la prennent pour une variable de substitution (constaté en dev ; les déploiements passent aussi par SQLcl). Écrire `chr(38)`.

## Packages

- Toute la logique est dans des packages : ni procédure ou fonction autonome, ni logique métier dans un trigger.
- La spec est le contrat public : une modification incompatible impose le `!` du commit (`git.md`).
- Documentation au format PLDoc (`/** … @param … @return … @throws … */`), dans la spec pour les routines publiques, dans le body pour les routines privées (jamais les deux pour une même routine), à l'intérieur du package (un commentaire avant `create or replace` est perdu par `project export`). Balises seulement quand elles ajoutent du sens : unité, signification de `null`, erreur levée.
- `COMMIT` et `ROLLBACK` uniquement dans les points d'entrée appelés par `DBMS_SCHEDULER`, jamais dans les procédures de service. Le code appelé par APEX n'en fait pas : APEX valide la transaction en fin de traitement.

## Erreurs et journalisation

- Journalisation avec Logger (OraOpenSource), installé dans un schéma dédié et appelé par synonymes. Pas de `DBMS_OUTPUT` dans le code livré.
- Pas de `WHEN OTHERS` sans journalisation et relance.
- Codes `RAISE_APPLICATION_ERROR` attribués par plage, une plage par package, déclarée en constantes dans sa spec.

## Collecte

- Appels HTTP par `APEX_WEB_SERVICE`, uniquement dans les packages de collecte.
- Les identifiants de l'API sont référencés par le nom d'un credential, jamais écrits dans le code.
- Un job `DBMS_SCHEDULER` s'exécute hors session APEX : établir le contexte du workspace avant d'utiliser un Web Credential APEX.

## Tests

- Chaque package public a son package de test utPLSQL `test_<package>`.
- utPLSQL n'existe qu'en dev et en CI : les packages de test ne sont jamais déployés en prod.

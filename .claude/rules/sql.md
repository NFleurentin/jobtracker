---
paths:
  - "src/database/**"
  - "dist/**"
  - ".dbtools/**"
  - "env/bootstrap/**/*.sql"
---

# Règles SQL

Ces règles couvrent le schéma (tables, vues, contraintes) et les migrations SQLcl. Le code PL/SQL est dans `plsql.md`.

## Migrations

- Tout objet du schéma applicatif est créé ou modifié par une migration du projet SQLcl. Un DDL joué à la main en dev est recapturé dans le dépôt avant le commit.
- Les prérequis qui demandent le compte d'administration (`SYS` en local, `ADMIN` sur ADB) relèvent des deux amorçages manuels décrits dans `env/bootstrap/`, pas des migrations : schémas (applicatif, Logger, et utPLSQL hors prod), droits, ACL réseau, workspace APEX, secret du credential.
- Une release déployée n'est jamais modifiée : Liquibase contrôle le checksum de ses changesets et le déploiement échouerait. Toute évolution passe par la release suivante.

## Modèle de données

- Nommage selon les Trivadis PL/SQL & SQL Coding Guidelines : tables et vues au pluriel, colonnes au singulier.
- Clé primaire technique en `GENERATED ALWAYS AS IDENTITY`.
- Contraintes toujours nommées (`<table>_pk`, `<table>_<cible>_fk`, `<table>_<colonnes>_uk`, `<table>_<objet>_ck`) : les noms générés (`SYS_C…`) diffèrent d'une base à l'autre et polluent les diffs SQLcl.
- Staging : réponse de l'API stockée brute dans une colonne de type `JSON`, sans transformation.
- Fichiers de données du dépôt : données fictives uniquement.

## Garde-fous pour l'agent

Demander une confirmation explicite avant tout DDL ou DML sur une base, et produire d'abord l'aperçu du déploiement (`liquibase update-sql`).

Interdit : se connecter en `SYS` ou en `ADMIN`, modifier des grants, des ACL réseau ou des credentials.

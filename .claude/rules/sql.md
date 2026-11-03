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
- Les prérequis qui demandent le compte d'administration (`SYS` en local, `ADMIN` sur ADB) relèvent des deux amorçages manuels décrits dans `env/bootstrap/`, pas des migrations : schémas (applicatif, Logger, et utPLSQL hors prod), droits, ACL réseau, workspace APEX.
- Le Web Credential de l'API se crée à la main dans le Builder, identifiants compris (`apex_credential` refuse le schéma applicatif et `SYS`) ; l'amorçage ne fait que le contrôler. Aucun script ne le crée ni ne contient ses identifiants.
- Une release déployée n'est jamais modifiée : Liquibase contrôle le checksum de ses changesets et le déploiement échouerait. Toute évolution passe par la release suivante.

## Modèle de données

- Nommage selon les Trivadis PL/SQL & SQL Coding Guidelines : tables et vues au pluriel, colonnes au singulier.
- Clé primaire technique en `GENERATED ALWAYS AS IDENTITY`, y compris pour une table d'association, avec une clé unique sur ses deux clés étrangères.
- Contraintes toujours nommées (`<table>_pk`, `<table>_<cible>_fk`, `<table>_<colonnes>_uk`, `<table>_<objet>_ck`) : les noms générés (`SYS_C…`) diffèrent d'une base à l'autre et polluent les diffs SQLcl. Index nommés `<table>_<colonnes>_i`.
- Toute clé étrangère est indexée (index dédié, ou colonnes en tête d'une clé unique) : sans index, un `DELETE` sur la table parente verrouille la table enfant.
- Vues en deux couches. Les vues `ui_` sont le contrat d'APEX : une par usage (région de page ou LOV), nommée `ui_<entité>_<usage>` (`ui_companies_list`, `ui_sectors_lov`). Elles ne font que choisir des colonnes et les présenter (horodatages en `timestamp with local time zone`, convertis par APEX dans le fuseau du navigateur) et lisent une vue de base, ou la table s'il n'y a rien à factoriser. Aucun objet du schéma ne lit une vue `ui_`.
- Une vue de base factorise une logique partagée (jointures, libellés, règle métier comme « offre active ») et se nomme d'après son contenu (`company_details`, `active_offers`). Une vue de base 1:1 sur une table, si elle est nécessaire, porte le suffixe `_v` (`companies_v`), une vue et une table ne pouvant pas partager un nom.
- Une contrainte qu'un formulaire peut violer reçoit son message dans le catalogue `app_messages`, sous le nom de la contrainte comme clé, sinon l'utilisateur voit le message générique.
- Staging : réponse de l'API stockée brute dans une colonne de type `JSON`, sans transformation.
- Fichiers de données du dépôt : données fictives uniquement.

## Garde-fous pour l'agent

Demander une confirmation explicite avant tout DDL ou DML sur une base, et produire d'abord l'aperçu du déploiement (`liquibase update-sql`).

Interdit : se connecter en `SYS` ou en `ADMIN`, modifier des grants, des ACL réseau ou des credentials.

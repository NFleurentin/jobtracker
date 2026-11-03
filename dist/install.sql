-- SQLcl uses the SQLCL engine for formatted sql changelog not the JDBC engine
-- By default, a project will not use substitution variables and allows blank
-- lines in sql statements.

set define off
set sqlblanklines on

-- Prechecks modifiable helper
-- Check running with SQLcl
-- Check minimum DB version
-- Check character set
--@utils/prechecks.sql

-- SLOT
-- Custom pre Liquibase code here (perhaps creation of a schema)
-- This is MINIMAL pre setup, everything that can go through Liquibase - SHOULD

-- Kick off Liquibase
prompt "Installing/updating schemas"
lb update -log -engine SQLCL -changelog-file releases/main.changelog.xml -search-path "." -def env/default.properties

-- Objets invalidés par les migrations (vues dépendant d'une table modifiée
-- ou d'une vue recréée) : Oracle les recompilerait au premier accès, mais le
-- déploiement doit laisser le schéma sans objet invalide (contrôlé en CI).
-- utils/recompile.sql, fourni par SQLcl, lit les vues dba_ : inaccessibles à
-- la session de déploiement.
prompt "Recompiling invalid objects"
exec dbms_utility.compile_schema(schema => user, compile_all => false)

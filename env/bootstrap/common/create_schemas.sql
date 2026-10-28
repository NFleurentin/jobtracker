-- =============================================================================
-- create_schemas.sql : schémas du projet, sans mot de passe (NO AUTHENTICATION)
--   - JOBTRACKER : schéma applicatif, dont les objets viennent des migrations
--   - LOGGER     : journalisation (OraOpenSource Logger)
-- Personne ne s'y connecte : APEX analyse les requêtes en tant que schéma et
-- les jobs DBMS_SCHEDULER tournent sans authentification. L'accès pour
-- déployer passera par un utilisateur proxy (étape SQLcl).
--
-- Joué par l'administrateur : SYS dans FREEPDB1 en dev, ADMIN sur ADB.
-- Paramètre : &1 = tablespace permanent (USERS en dev, DATA sur ADB).
-- Rejouable. CREATE USER IF NOT EXISTS demande la 23ai ou plus.
-- =============================================================================
create user if not exists jobtracker no authentication
   default tablespace &1
   quota unlimited on &1;

-- Droits directs, pas par rôle : le PL/SQL en droits du définisseur les ignore
grant create table, create view, create sequence, create procedure,
      create trigger, create type, create synonym, create job
   to jobtracker;

create user if not exists logger no authentication
   default tablespace &1
   quota unlimited on &1;

-- Droits contrôlés par logger_install.sql. CREATE SESSION ne sert qu'à
-- l'installation, jouée connecté en LOGGER avec un mot de passe jetable.
grant create session, create table, create view, create sequence,
      create procedure, create trigger, create any context, create job
   to logger;

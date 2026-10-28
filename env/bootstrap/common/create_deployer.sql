-- =============================================================================
-- create_deployer.sql : compte de déploiement, connecté par proxy
--   - JOBTRACKER_DEPLOY : ouvre pour SQLcl des sessions en tant que
--     JOBTRACKER (jobtracker_deploy[jobtracker]) ; aucun autre droit.
-- Les objets sont créés par leur propriétaire, sans privilège ANY, et
-- JOBTRACKER reste sans mot de passe.
--
-- Le mot de passe n'est pas fixé ici : le compte est créé sans, puis
-- l'administrateur le fixe à part (dev.sh bootstrap en dev, à la main sur
-- ADB). Aucun secret ne passe donc en paramètre de ce script.
--
-- Joué par l'administrateur, après create_schemas.sql. Rejouable.
-- =============================================================================
create user if not exists jobtracker_deploy no authentication;

grant create session to jobtracker_deploy;

-- Une session proxy porte les droits du schéma cible, y compris
-- CREATE SESSION (sinon ORA-01045). Sans mot de passe, JOBTRACKER n'est
-- toujours pas joignable directement.
grant create session to jobtracker;

declare
   l_count pls_integer;
begin
   select count(*)
     into l_count
     from proxy_users
    where proxy = 'JOBTRACKER_DEPLOY'
      and client = 'JOBTRACKER';

   if l_count = 0 then
      execute immediate 'alter user jobtracker grant connect through jobtracker_deploy';
   end if;
end;
/

-- =============================================================================
-- create_workspace.sql : workspace APEX du projet
--   - JOBTRACKER : workspace dont le schéma d'analyse est JOBTRACKER
-- L'identifiant du workspace est attribué par APEX : à l'import, l'application
-- est rattachée au workspace cible, quel que soit son identifiant.
--
-- Aucun utilisateur APEX n'est créé ici : un mot de passe n'a pas sa place
-- dans un script du dépôt. Le développeur est créé à part (dev.sh bootstrap
-- en dev, à la main sur ADB).
--
-- Joué par l'administrateur, après create_schemas.sql. Rejouable.
-- =============================================================================
declare
   l_count pls_integer;
begin
   select count(*)
     into l_count
     from apex_workspaces
    where workspace = 'JOBTRACKER';

   if l_count = 0 then
      apex_instance_admin.add_workspace(
         p_workspace      => 'JOBTRACKER',
         p_primary_schema => 'JOBTRACKER'
      );
   end if;
end;
/

commit;

-- =============================================================================
-- ui_defaults.sql : libellés français des colonnes courantes (UI Defaults)
--   - Attribute Dictionary du workspace JOBTRACKER : un libellé par nom de
--     colonne, quelle que soit la vue.
--   - Lu par l'assistant des Forms à la création d'une page : le libellé est
--     copié dans la page, une modification ici ne change pas les pages
--     existantes. L'assistant des Interactive Reports ne lit pas les UI
--     Defaults (constaté avec APEX 26.1) : les en-têtes de liste se traduisent
--     à la main, avec les libellés ci-dessous.
-- Ce script fait foi : le dictionnaire du workspace est vidé puis recréé.
-- Une colonne propre à une seule page se traduit sur la page, pas ici.
--
-- Dev uniquement (les UI Defaults ne servent qu'au Builder).
-- Joué en JOBTRACKER, schéma du workspace, après create_workspace.sql :
-- apex_ui_default_update est en droits de l'appelant, et SYS n'accorde pas
-- INHERIT PRIVILEGES au schéma d'APEX (ORA-06598, protection voulue, à ne pas
-- lever). Rejouable.
-- =============================================================================
declare
   procedure add_attribute (
      p_column_name in varchar2,
      p_label       in varchar2
   )
   is
   begin
      apex_ui_default_update.add_ad_column(
         p_column_name => p_column_name,
         p_label       => p_label
      );
   end add_attribute;
begin
   apex_util.set_workspace(p_workspace => 'JOBTRACKER');

   <<remove_attributes>>
   for r_attribute in (
      select column_name
        from apex_ui_defaults_attr_dict
       where workspace = 'JOBTRACKER'
         and synonym_of is null
   )
   loop
      apex_ui_default_update.del_ad_column(p_column_name => r_attribute.column_name);
   end loop remove_attributes;

   -- Colonnes techniques
   add_attribute('CREATED_AT', 'Créée le');
   add_attribute('UPDATED_AT', 'Modifiée le');

   -- Référentiels
   add_attribute('COMPANY_TYPE_ID', 'Type');
   add_attribute('SECTOR_ID', 'Secteur');
   add_attribute('COMPANY_SIZE_ID', 'Taille');
   add_attribute('LOCATION_ID', 'Lieu');

   -- Entreprise, reprise par les offres, les candidatures et les contacts
   add_attribute('COMPANY_ID', 'Entreprise');
   add_attribute('PARENT_COMPANY_ID', 'Entreprise parente');
   add_attribute('CREATION_YEAR', 'Année de création');

   -- Textes libres et coordonnées
   add_attribute('DESCRIPTION', 'Description');
   add_attribute('NOTE_TEXT', 'Notes');
   add_attribute('WEBSITE_URL', 'Site web');
   add_attribute('LINKEDIN_SLUG', 'Identifiant Linkedin');
   add_attribute('EMAIL', 'Courriel');
   add_attribute('PHONE', 'Téléphone');
   add_attribute('SIREN', 'SIREN');
end;
/

commit;

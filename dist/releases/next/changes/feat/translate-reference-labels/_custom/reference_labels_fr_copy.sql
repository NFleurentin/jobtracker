-- liquibase formatted sql
-- changeset  SqlCl:1793724750698 stripComments:false logicalFilePath:_custom/reference_labels_fr_copy.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/translate-reference-labels/_custom/reference_labels_fr_copy.sql:null:null:custom




-- =============================================================================
-- reference_labels_fr_copy.sql : libellés français copiés dans les colonnes _fr
--
-- Première étape d'un renommage que project stage ne sait pas exprimer (il
-- génère un ajout puis un drop, qui perd la donnée) : les colonnes d'origine
-- restent jusqu'au changement suivant, qui rend les colonnes _fr obligatoires
-- avant de supprimer les anciennes.
-- Rejouable : seules les lignes différentes, null compris, sont réécrites.
-- =============================================================================
update jobtracker.sectors
   set sector_name_fr = sector_name
 where lnnvl(sector_name_fr = sector_name);

update jobtracker.company_types
   set company_type_name_fr = company_type_name
 where lnnvl(company_type_name_fr = company_type_name);

update jobtracker.company_sizes
   set company_size_short_name_fr = company_size_short_name,
       company_size_long_name_fr = company_size_long_name
 where lnnvl(company_size_short_name_fr = company_size_short_name)
    or lnnvl(company_size_long_name_fr = company_size_long_name);

update jobtracker.location_types
   set location_type_name_fr = location_type_name
 where lnnvl(location_type_name_fr = location_type_name);

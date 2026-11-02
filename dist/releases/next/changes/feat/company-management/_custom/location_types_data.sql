-- liquibase formatted sql
-- changeset  SqlCl:1793627624103 stripComments:false logicalFilePath:_custom/location_types_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/company-management/_custom/location_types_data.sql:null:null:custom




-- =============================================================================
-- location_types_data.sql : référentiel des types de lieu
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Rejouable : un type déjà présent n'est pas modifié.
-- =============================================================================
insert into location_types (location_type_code, location_type_name)
select v.location_type_code, v.location_type_name
  from (values ('COUNTRY',      'Pays'),
               ('REGION',       'Région'),
               ('DEPARTMENT',   'Département'),
               ('MUNICIPALITY', 'Commune'),
               ('ADDRESS',      'Adresse')) v (location_type_code, location_type_name)
 where not exists (
          select null
            from location_types t
           where t.location_type_code = v.location_type_code
       );

-- liquibase formatted sql
-- changeset  SqlCl:1793626275252 stripComments:false logicalFilePath:_custom/company_types_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/company-management/_custom/company_types_data.sql:null:null:custom




-- =============================================================================
-- company_types_data.sql : référentiel des types d'entreprise
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Rejouable : un type déjà présent n'est pas modifié.
-- =============================================================================
insert into company_types (company_type_code, company_type_name)
select v.company_type_code, v.company_type_name
  from (values ('ESN',              'ESN'),
               ('RECRUITMENT_FIRM', 'Cabinet de recrutement'),
               ('DIRECT_EMPLOYER',  'Employeur direct'),
               ('CIVIL_SERVICE',    'Fonction publique')) v (company_type_code, company_type_name)
 where not exists (
          select null
            from company_types t
           where t.company_type_code = v.company_type_code
       );

-- liquibase formatted sql
-- changeset  SqlCl:1793626951057 stripComments:false logicalFilePath:_custom/company_sizes_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/company-management/_custom/company_sizes_data.sql:null:null:custom




-- =============================================================================
-- company_sizes_data.sql : référentiel des tailles d'entreprise
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Rejouable : une taille déjà présente n'est pas modifiée.
-- =============================================================================
insert into company_sizes (company_size_short_name, company_size_long_name, display_order)
select v.company_size_short_name, v.company_size_long_name, v.display_order
  from (values ('TPE', 'Très petite entreprise',             10),
               ('PME', 'Petite ou moyenne entreprise',       20),
               ('ETI', 'Entreprise de taille intermédiaire', 30),
               ('GE',  'Grande entreprise',                  40)) v (company_size_short_name, company_size_long_name, display_order)
 where not exists (
          select null
            from company_sizes s
           where s.company_size_short_name = v.company_size_short_name
       );

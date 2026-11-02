-- liquibase formatted sql
-- changeset  SqlCl:1793627301838 stripComments:false logicalFilePath:_custom/sectors_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/company-management/_custom/sectors_data.sql:null:null:custom




-- =============================================================================
-- sectors_data.sql : référentiel des secteurs d'activité
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Rejouable : un secteur déjà présent n'est pas modifié.
-- =============================================================================
insert into sectors (sector_name)
select v.sector_name
  from (values ('Administration publique'),
               ('Assurance'),
               ('Banque'),
               ('Commerce et distribution'),
               ('Éducation et recherche'),
               ('Énergie'),
               ('Industrie'),
               ('Médias'),
               ('Numérique'),
               ('Santé'),
               ('Télécommunications'),
               ('Transport et logistique')) v (sector_name)
 where not exists (
          select null
            from sectors s
           where s.sector_name = v.sector_name
       );

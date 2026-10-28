-- liquibase formatted sql
-- changeset  SqlCl:1793194916678 stripComments:false logicalFilePath:_custom/offer_sources_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/collect-staging/_custom/offer_sources_data.sql:null:null:custom

-- =============================================================================
-- offer_sources_data.sql : référentiel des sources d'offres
--   - FRANCE_TRAVAIL : API Offres d'emploi, collectée par la base
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Rejouable : une source déjà présente n'est pas modifiée.
-- =============================================================================
insert into offer_sources (source_code, source_name)
select 'FRANCE_TRAVAIL', 'France Travail'
  from dual
 where not exists (
          select null
            from offer_sources
           where source_code = 'FRANCE_TRAVAIL'
       );

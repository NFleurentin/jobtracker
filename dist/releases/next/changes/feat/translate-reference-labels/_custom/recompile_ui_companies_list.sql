-- liquibase formatted sql
-- changeset  SqlCl:1793724750965 stripComments:false logicalFilePath:_custom/recompile_ui_companies_list.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/translate-reference-labels/_custom/recompile_ui_companies_list.sql:null:null:custom




-- =============================================================================
-- recompile_ui_companies_list.sql : vue de la liste des entreprises recompilée
--
-- Recréer company_details invalide ui_companies_list, qui la lit : Oracle la
-- recompilerait au premier accès, mais le déploiement doit laisser le schéma
-- sans objet invalide (contrôlé en CI).
-- =============================================================================
alter view jobtracker.ui_companies_list compile;

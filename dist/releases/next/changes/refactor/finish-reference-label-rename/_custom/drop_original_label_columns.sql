-- liquibase formatted sql
-- changeset  SqlCl:1793725895541 stripComments:false logicalFilePath:_custom/drop_original_label_columns.sql
-- sqlcl_snapshot dist/releases/next/changes/refactor/finish-reference-label-rename/_custom/drop_original_label_columns.sql:null:null:custom




-- =============================================================================
-- drop_original_label_columns.sql : colonnes de libellé d'origine supprimées
--
-- Seconde étape du renommage commencé par #68, que project stage ne sait pas
-- exprimer : il laisse en commentaire la suppression d'une colonne, et
-- réécrit un changeset généré retouché à la main. Joué après les changesets
-- générés qui rendent les colonnes _fr obligatoires : une copie incomplète
-- arrête le déploiement avant toute suppression.
-- Supprimer une colonne emporte sa clé unique mono-colonne et son index, et
-- invalide les vues de la table, recompilées ensuite (le déploiement doit
-- laisser le schéma sans objet invalide, contrôlé en CI).
-- =============================================================================
alter table jobtracker.sectors drop ( sector_name );
alter table jobtracker.company_types drop ( company_type_name );
alter table jobtracker.company_sizes drop ( company_size_short_name, company_size_long_name );
alter table jobtracker.location_types drop ( location_type_name );

alter view jobtracker.company_details compile;
alter view jobtracker.ui_companies_list compile;
alter view jobtracker.ui_sectors_lov compile;
alter view jobtracker.ui_company_types_lov compile;
alter view jobtracker.ui_company_sizes_lov compile;

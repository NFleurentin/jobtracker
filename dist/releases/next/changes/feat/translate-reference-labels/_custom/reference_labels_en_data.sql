-- liquibase formatted sql
-- changeset  SqlCl:1793723879245 stripComments:false logicalFilePath:_custom/reference_labels_en_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/translate-reference-labels/_custom/reference_labels_en_data.sql:null:null:custom




-- =============================================================================
-- reference_labels_en_data.sql : libellés anglais des référentiels
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Joué après l'ajout des colonnes anglaises, encore nullables : elles
-- deviennent obligatoires dans un changement suivant, une fois remplies
-- partout (project stage ajouterait sinon une colonne not null à une table
-- remplie, ce qui échoue).
-- Rejouable : rattaché par le code du référentiel s'il en a un, sinon par le
-- libellé français ; une ligne absente du dépôt garde un libellé anglais vide.
-- =============================================================================
merge into jobtracker.sectors t
using (
    values ( 'Administration publique', 'Public administration' ),
           ( 'Assurance', 'Insurance' ),
           ( 'Banque', 'Banking' ),
           ( 'Commerce et distribution', 'Retail and distribution' ),
           ( 'Éducation et recherche', 'Education and research' ),
           ( 'Énergie', 'Energy' ),
           ( 'Industrie', 'Manufacturing' ),
           ( 'Médias', 'Media' ),
           ( 'Numérique', 'Digital' ),
           ( 'Santé', 'Healthcare' ),
           ( 'Télécommunications', 'Telecommunications' ),
           ( 'Transport et logistique', 'Transport and logistics' )
) v ( sector_name, sector_name_en )
on ( t.sector_name = v.sector_name )
when matched then
    update set t.sector_name_en = v.sector_name_en;

merge into jobtracker.company_types t
using (
    values ( 'ESN', 'IT consultancy' ),
           ( 'RECRUITMENT_FIRM', 'Recruitment agency' ),
           ( 'DIRECT_EMPLOYER', 'Direct employer' ),
           ( 'CIVIL_SERVICE', 'Civil service' )
) v ( company_type_code, company_type_name_en )
on ( t.company_type_code = v.company_type_code )
when matched then
    update set t.company_type_name_en = v.company_type_name_en;

merge into jobtracker.company_sizes t
using (
    values ( 'TPE', 'Micro', 'Micro-enterprise' ),
           ( 'PME', 'SME', 'Small or medium-sized enterprise' ),
           ( 'ETI', 'Mid-cap', 'Mid-sized enterprise' ),
           ( 'GE', 'Large', 'Large enterprise' )
) v ( company_size_short_name, company_size_short_name_en, company_size_long_name_en )
on ( t.company_size_short_name = v.company_size_short_name )
when matched then
    update set t.company_size_short_name_en = v.company_size_short_name_en,
               t.company_size_long_name_en = v.company_size_long_name_en;

merge into jobtracker.location_types t
using (
    values ( 'COUNTRY', 'Country' ),
           ( 'REGION', 'Region' ),
           ( 'DEPARTMENT', 'Department' ),
           ( 'MUNICIPALITY', 'Municipality' ),
           ( 'ADDRESS', 'Address' )
) v ( location_type_code, location_type_name_en )
on ( t.location_type_code = v.location_type_code )
when matched then
    update set t.location_type_name_en = v.location_type_name_en;


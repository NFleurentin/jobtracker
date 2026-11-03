-- liquibase formatted sql
-- changeset  SqlCl:1793723247989 stripComments:false logicalFilePath:_custom/reference_labels_en.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/translate-reference-labels/_custom/reference_labels_en.sql:null:null:custom




-- =============================================================================
-- reference_labels_en.sql : libellés des référentiels en français et en anglais
--
-- Écrit à la main et joué avant les changesets générés par project stage
-- pour les quatre tables : SQLcl ne détecte pas le renommage d'une colonne (il
-- génère un ajout puis un drop, qui perd la donnée) et ajoute les colonnes
-- directement en not null, ce qui échoue sur une table remplie. Ceux de
-- project stage restent dans dist/, sinon il les régénère :
-- une précondition (onFail:MARK_RAN) les marque joués sans les exécuter
-- quand leur colonne ou leur contrainte existe déjà.
-- Une colonne anglaise s'ajoute nullable, se remplit, puis devient
-- obligatoire : un libellé sans traduction fait échouer le déploiement.
-- Un seul changeset : un échec au milieu laisse les DDL déjà joués (commit
-- implicite), à reprendre à la main avant de rejouer.
-- =============================================================================

-- 1. Libellés existants renommés en _fr, contraintes et index avec eux
alter table jobtracker.sectors rename column sector_name to sector_name_fr;
alter table jobtracker.sectors rename constraint sectors_sector_name_uk to sectors_sector_name_fr_uk;
alter index jobtracker.sectors_sector_name_uk rename to sectors_sector_name_fr_uk;

alter table jobtracker.company_types rename column company_type_name to company_type_name_fr;
alter table jobtracker.company_types rename constraint company_types_company_type_name_uk to company_types_company_type_name_fr_uk;
alter index jobtracker.company_types_company_type_name_uk rename to company_types_company_type_name_fr_uk;

alter table jobtracker.company_sizes rename column company_size_short_name to company_size_short_name_fr;
alter table jobtracker.company_sizes rename constraint company_sizes_company_size_short_name_uk to company_sizes_company_size_short_name_fr_uk;
alter index jobtracker.company_sizes_company_size_short_name_uk rename to company_sizes_company_size_short_name_fr_uk;
alter table jobtracker.company_sizes rename column company_size_long_name to company_size_long_name_fr;
alter table jobtracker.company_sizes rename constraint company_sizes_company_size_long_name_uk to company_sizes_company_size_long_name_fr_uk;
alter index jobtracker.company_sizes_company_size_long_name_uk rename to company_sizes_company_size_long_name_fr_uk;

alter table jobtracker.location_types rename column location_type_name to location_type_name_fr;
alter table jobtracker.location_types rename constraint location_types_location_type_name_uk to location_types_location_type_name_fr_uk;
alter index jobtracker.location_types_location_type_name_uk rename to location_types_location_type_name_fr_uk;

-- 2. Colonnes anglaises, nullables le temps de les remplir
alter table jobtracker.sectors add ( sector_name_en varchar2(100 char) );
alter table jobtracker.company_types add ( company_type_name_en varchar2(100 char) );
alter table jobtracker.company_sizes add ( company_size_short_name_en varchar2(10 char), company_size_long_name_en varchar2(100 char) );
alter table jobtracker.location_types add ( location_type_name_en varchar2(100 char) );

-- 3. Libellés anglais, rattachés par le code du référentiel s'il en a un,
--    sinon par le libellé français
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
) v ( sector_name_fr, sector_name_en )
on ( t.sector_name_fr = v.sector_name_fr )
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
) v ( company_size_short_name_fr, company_size_short_name_en, company_size_long_name_en )
on ( t.company_size_short_name_fr = v.company_size_short_name_fr )
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

-- 4. Colonnes anglaises obligatoires et uniques, comme les françaises
alter table jobtracker.sectors modify ( sector_name_en not null );
alter table jobtracker.sectors add constraint sectors_sector_name_en_uk unique ( sector_name_en );

alter table jobtracker.company_types modify ( company_type_name_en not null );
alter table jobtracker.company_types add constraint company_types_company_type_name_en_uk unique ( company_type_name_en );

alter table jobtracker.company_sizes modify ( company_size_short_name_en not null, company_size_long_name_en not null );
alter table jobtracker.company_sizes add constraint company_sizes_company_size_short_name_en_uk unique ( company_size_short_name_en );
alter table jobtracker.company_sizes add constraint company_sizes_company_size_long_name_en_uk unique ( company_size_long_name_en );

alter table jobtracker.location_types modify ( location_type_name_en not null );
alter table jobtracker.location_types add constraint location_types_location_type_name_en_uk unique ( location_type_name_en );


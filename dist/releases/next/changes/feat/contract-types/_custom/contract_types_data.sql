-- liquibase formatted sql
-- changeset  SqlCl:1794411221368 stripComments:false logicalFilePath:_custom/contract_types_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/contract-types/_custom/contract_types_data.sql:null:null:custom



-- =============================================================================
-- contract_types_data.sql : référentiel des types de contrat
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Liste fixe, sans écran de maintenance : le code est la clé des packages.
-- Rejouable : un type déjà présent n'est pas modifié.
-- =============================================================================
insert into contract_types (
    contract_type_code,
    contract_type_name_fr,
    contract_type_name_en
)
select
    v.contract_type_code,
    v.contract_type_name_fr,
    v.contract_type_name_en
from
    (
        values ( 'PERMANENT', 'CDI', 'Permanent' ),
               ( 'FIXED_TERM', 'CDD', 'Fixed-term' ),
               ( 'FREELANCE', 'Freelance', 'Freelance' ),
               ( 'TEMPORARY', 'Intérim', 'Temporary' ),
               ( 'WORK_STUDY', 'Alternance', 'Work-study' ),
               ( 'INTERNSHIP', 'Stage', 'Internship' )
    ) v ( contract_type_code, contract_type_name_fr, contract_type_name_en )
where
    not exists (
        select
            null
        from
            contract_types t
        where
            t.contract_type_code = v.contract_type_code
    );

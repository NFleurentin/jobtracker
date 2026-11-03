-- liquibase formatted sql
-- changeset  SqlCl:1793737922577 stripComments:false logicalFilePath:_custom/salutations_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/contacts-data-model/_custom/salutations_data.sql:null:null:custom



-- =============================================================================
-- salutations_data.sql : référentiel des civilités
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Rejouable : une civilité déjà présente n'est pas modifiée.
-- =============================================================================
insert into salutations (
    salutation_code,
    salutation_short_name_fr,
    salutation_long_name_fr,
    salutation_short_name_en,
    salutation_long_name_en
)
select
    v.salutation_code,
    v.salutation_short_name_fr,
    v.salutation_long_name_fr,
    v.salutation_short_name_en,
    v.salutation_long_name_en
from
    (
        values ( 'MR', 'M.', 'Monsieur', 'Mr', 'Mister' ),
               ( 'MS', 'Mme', 'Madame', 'Ms', 'Madam' )
    ) v ( salutation_code, salutation_short_name_fr, salutation_long_name_fr, salutation_short_name_en, salutation_long_name_en )
where
    not exists (
        select
            null
        from
            salutations s
        where
            s.salutation_code = v.salutation_code
    );

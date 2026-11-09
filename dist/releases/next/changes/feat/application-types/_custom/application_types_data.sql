-- liquibase formatted sql
-- changeset  SqlCl:1794233665627 stripComments:false logicalFilePath:_custom/application_types_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/application-types/_custom/application_types_data.sql:null:null:custom



-- =============================================================================
-- application_types_data.sql : référentiel des types de candidature
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Liste fixe, sans écran de maintenance : le code est la clé des packages.
-- Rejouable : un type déjà présent n'est pas modifié.
-- =============================================================================
insert into application_types (
    application_type_code,
    application_type_name_fr,
    application_type_name_en
)
select
    v.application_type_code,
    v.application_type_name_fr,
    v.application_type_name_en
from
    (
        values ( 'SPONTANEOUS', 'Candidature spontanée', 'Unsolicited application' ),
               ( 'JOB_OFFER', 'Réponse à une offre', 'Job offer response' ),
               ( 'APPROACHED', 'Approche de l''entreprise', 'Approached by company' )
    ) v ( application_type_code, application_type_name_fr, application_type_name_en )
where
    not exists (
        select
            null
        from
            application_types t
        where
            t.application_type_code = v.application_type_code
    );

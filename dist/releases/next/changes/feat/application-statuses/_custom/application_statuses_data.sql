-- liquibase formatted sql
-- changeset  SqlCl:1794235614155 stripComments:false logicalFilePath:_custom/application_statuses_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/application-statuses/_custom/application_statuses_data.sql:null:null:custom



-- =============================================================================
-- application_statuses_data.sql : référentiel des statuts de candidature
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Liste fixe, sans écran de maintenance : le code est la clé des packages.
-- funnel_step : étapes mesurées du funnel, null pour une sortie du funnel.
-- Rejouable : un statut déjà présent n'est pas modifié.
-- =============================================================================
insert into application_statuses (
    application_status_code,
    application_status_name_fr,
    application_status_name_en,
    display_order,
    funnel_step,
    is_final
)
select
    v.application_status_code,
    v.application_status_name_fr,
    v.application_status_name_en,
    v.display_order,
    v.funnel_step,
    v.is_final
from
    (
        values ( 'TO_APPLY', 'À candidater', 'To apply', 10, 1, false ),
               ( 'APPLIED', 'Candidature envoyée', 'Applied', 20, 2, false ),
               ( 'INTERVIEWING', 'Entretiens en cours', 'Interviewing', 30, 3, false ),
               ( 'OFFER_RECEIVED', 'Proposition reçue', 'Offer received', 40, 4, false ),
               ( 'ACCEPTED', 'Acceptée', 'Accepted', 50, 5, true ),
               ( 'REJECTED', 'Refusée par l''entreprise', 'Rejected', 60, null, true ),
               ( 'WITHDRAWN', 'Abandonnée', 'Withdrawn', 70, null, true ),
               ( 'NO_RESPONSE', 'Sans réponse', 'No response', 80, null, true )
    ) v ( application_status_code, application_status_name_fr, application_status_name_en, display_order, funnel_step, is_final )
where
    not exists (
        select
            null
        from
            application_statuses s
        where
            s.application_status_code = v.application_status_code
    );

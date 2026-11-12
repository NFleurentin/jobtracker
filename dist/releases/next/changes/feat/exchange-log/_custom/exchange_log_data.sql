-- liquibase formatted sql
-- changeset  SqlCl:1794482528035 stripComments:false logicalFilePath:_custom/exchange_log_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/exchange-log/_custom/exchange_log_data.sql:null:null:custom



-- =============================================================================
-- exchange_log_data.sql : référentiels du journal des échanges
--
-- Données de référence, hors de project export (dml désactivé dans le projet).
-- Listes fixes, sans écran de maintenance : le code est la clé des packages
-- (constantes de exchange_log).
-- Rejouable : une ligne déjà présente n'est pas modifiée.
-- =============================================================================
insert into external_systems (
    external_system_code,
    external_system_name_fr,
    external_system_name_en
)
select
    v.external_system_code,
    v.external_system_name_fr,
    v.external_system_name_en
from
    (
        values ( 'FRANCE_TRAVAIL', 'France Travail', 'France Travail' )
    ) v ( external_system_code, external_system_name_fr, external_system_name_en )
where
    not exists (
        select
            null
        from
            external_systems t
        where
            t.external_system_code = v.external_system_code
    );

insert into exchange_protocols (
    exchange_protocol_code,
    exchange_protocol_name_fr,
    exchange_protocol_name_en
)
select
    v.exchange_protocol_code,
    v.exchange_protocol_name_fr,
    v.exchange_protocol_name_en
from
    (
        values ( 'HTTP', 'HTTP', 'HTTP' )
    ) v ( exchange_protocol_code, exchange_protocol_name_fr, exchange_protocol_name_en )
where
    not exists (
        select
            null
        from
            exchange_protocols t
        where
            t.exchange_protocol_code = v.exchange_protocol_code
    );

insert into exchange_statuses (
    exchange_status_code,
    exchange_status_name_fr,
    exchange_status_name_en
)
select
    v.exchange_status_code,
    v.exchange_status_name_fr,
    v.exchange_status_name_en
from
    (
        values ( 'PENDING', 'En cours', 'Pending' ),
               ( 'COMPLETED', 'Terminé', 'Completed' ),
               ( 'FAILED', 'Échoué', 'Failed' )
    ) v ( exchange_status_code, exchange_status_name_fr, exchange_status_name_en )
where
    not exists (
        select
            null
        from
            exchange_statuses t
        where
            t.exchange_status_code = v.exchange_status_code
    );

-- liquibase formatted sql
-- changeset JOBTRACKER:1794901005412 stripComments:false  logicalFilePath:feat/external-systems-settings/jobtracker/views/ui_external_systems_list.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_external_systems_list.sql:null:a61e455ede8689d63845738302eefbaf49bc65a2:create

create or replace force editionable view jobtracker.ui_external_systems_list (
    external_system_id,
    external_system_name,
    retention_days,
    orphan_delay_minutes,
    is_exchange_logged
) as
    select
        external_system_id,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                external_system_name_en
            else
                external_system_name_fr
        end as external_system_name,
        retention_days,
        orphan_delay_minutes,
        is_exchange_logged
    from
        jobtracker.external_systems
with read only;


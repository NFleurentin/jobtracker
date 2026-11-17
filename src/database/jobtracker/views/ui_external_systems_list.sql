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


-- sqlcl_snapshot {"hash":"a61e455ede8689d63845738302eefbaf49bc65a2","type":"VIEW","name":"UI_EXTERNAL_SYSTEMS_LIST","schemaName":"JOBTRACKER","sxml":""}
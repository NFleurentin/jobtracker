create or replace force editionable view jobtracker.ui_exchange_statuses_lov (
    return_value,
    display_value
) as
    select
        exchange_status_id as return_value,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                exchange_status_name_en
            else
                exchange_status_name_fr
        end                as display_value
    from
        jobtracker.exchange_statuses
with read only;


-- sqlcl_snapshot {"hash":"d94278a1782405d860f7ea54f70982fb24486e92","type":"VIEW","name":"UI_EXCHANGE_STATUSES_LOV","schemaName":"JOBTRACKER","sxml":""}
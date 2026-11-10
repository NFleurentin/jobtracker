create or replace force editionable view jobtracker.ui_application_statuses_lov (
    return_value,
    display_value,
    display_order
) as
    select
        application_status_id as return_value,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                application_status_name_en
            else
                application_status_name_fr
        end                   as display_value,
        display_order
    from
        jobtracker.application_statuses
with read only;


-- sqlcl_snapshot {"hash":"66f00986a40a6e387aa9e9c0d48fc14516167213","type":"VIEW","name":"UI_APPLICATION_STATUSES_LOV","schemaName":"JOBTRACKER","sxml":""}
create or replace force editionable view jobtracker.ui_external_systems_lov (
    return_value,
    display_value
) as
    select
        external_system_id as return_value,
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
        end                as display_value
    from
        jobtracker.external_systems
with read only;


-- sqlcl_snapshot {"hash":"fc9e6111c12d8f36b54e7691a719340cd71c9839","type":"VIEW","name":"UI_EXTERNAL_SYSTEMS_LOV","schemaName":"JOBTRACKER","sxml":""}
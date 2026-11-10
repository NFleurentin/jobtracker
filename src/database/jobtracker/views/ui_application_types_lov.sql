create or replace force editionable view jobtracker.ui_application_types_lov (
    return_value,
    display_value
) as
    select
        application_type_id as return_value,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                application_type_name_en
            else
                application_type_name_fr
        end                 as display_value
    from
        jobtracker.application_types
with read only;


-- sqlcl_snapshot {"hash":"149cb03a860d2a071e10a43ea340e499c439a7fa","type":"VIEW","name":"UI_APPLICATION_TYPES_LOV","schemaName":"JOBTRACKER","sxml":""}
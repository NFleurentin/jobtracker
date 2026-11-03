create or replace force editionable view jobtracker.ui_company_types_lov (
    return_value,
    display_value
) as
    select
        company_type_id as return_value,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                company_type_name_en
            else
                company_type_name
        end             as display_value
    from
        jobtracker.company_types
with read only;


-- sqlcl_snapshot {"hash":"3165a50a2c8f64366e5bf77be24b5eaf809081e0","type":"VIEW","name":"UI_COMPANY_TYPES_LOV","schemaName":"JOBTRACKER","sxml":""}
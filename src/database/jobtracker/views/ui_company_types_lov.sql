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
                company_type_name_fr
        end             as display_value
    from
        jobtracker.company_types
with read only;


-- sqlcl_snapshot {"hash":"3858b431e8da229bd619b8ce0764179416efea93","type":"VIEW","name":"UI_COMPANY_TYPES_LOV","schemaName":"JOBTRACKER","sxml":""}
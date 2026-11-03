create or replace force editionable view jobtracker.ui_salutations_lov (
    return_value,
    display_value
) as
    select
        salutation_id as return_value,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                salutation_long_name_en
            else
                salutation_long_name_fr
        end           as display_value
    from
        jobtracker.salutations
with read only;


-- sqlcl_snapshot {"hash":"f5031bc3d586a4f35f94a7a8b21dcf0e0eafcb2c","type":"VIEW","name":"UI_SALUTATIONS_LOV","schemaName":"JOBTRACKER","sxml":""}
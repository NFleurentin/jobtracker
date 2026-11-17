create or replace force editionable view jobtracker.ui_ft_communes_lov (
    return_value,
    display_value
) as
    select
        commune_code as return_value,
        commune_name
        ||
        case
            when department_code is not null then
                    ' ('
                    || department_code
                    || ')'
        end
        as display_value
    from
        jobtracker.ft_commune_details
    where
        is_current
with read only;


-- sqlcl_snapshot {"hash":"d3faca5de55fd6b0303efc7fb9859ce3eed5090c","type":"VIEW","name":"UI_FT_COMMUNES_LOV","schemaName":"JOBTRACKER","sxml":""}
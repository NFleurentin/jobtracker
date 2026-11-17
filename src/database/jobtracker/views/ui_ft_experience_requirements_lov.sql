create or replace force editionable view jobtracker.ui_ft_experience_requirements_lov (
    return_value,
    display_value
) as
    select
        experience_requirement_code as return_value,
        experience_requirement_name as display_value
    from
        jobtracker.ft_experience_requirements
with read only;


-- sqlcl_snapshot {"hash":"f993fc17f64c1241f2e19cc6554e05ba96842a1e","type":"VIEW","name":"UI_FT_EXPERIENCE_REQUIREMENTS_LOV","schemaName":"JOBTRACKER","sxml":""}
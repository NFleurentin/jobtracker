create or replace force editionable view jobtracker.ui_ft_experiences_lov (
    return_value,
    display_value
) as
    select
        experience_code as return_value,
        experience_name as display_value
    from
        jobtracker.ft_experiences
with read only;


-- sqlcl_snapshot {"hash":"47d89a934e2d529d08cb6c653216248450308a1e","type":"VIEW","name":"UI_FT_EXPERIENCES_LOV","schemaName":"JOBTRACKER","sxml":""}
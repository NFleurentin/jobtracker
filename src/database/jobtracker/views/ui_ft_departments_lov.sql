create or replace force editionable view jobtracker.ui_ft_departments_lov (
    return_value,
    display_value
) as
    select
        department_code as return_value,
        department_name
        || ' ('
        || department_code
        || ')'          as display_value
    from
        jobtracker.ft_department_details
    where
        is_current
with read only;


-- sqlcl_snapshot {"hash":"b1091f2fbc227c5ba26d9b055bdb37809bfaab60","type":"VIEW","name":"UI_FT_DEPARTMENTS_LOV","schemaName":"JOBTRACKER","sxml":""}
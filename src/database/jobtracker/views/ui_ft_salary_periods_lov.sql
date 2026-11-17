create or replace force editionable view jobtracker.ui_ft_salary_periods_lov (
    return_value,
    display_value
) as
    select
        salary_period_code as return_value,
        salary_period_name as display_value
    from
        jobtracker.ft_salary_periods
with read only;


-- sqlcl_snapshot {"hash":"d9aae39b643e2d01104ceec4e5daf7822b981470","type":"VIEW","name":"UI_FT_SALARY_PERIODS_LOV","schemaName":"JOBTRACKER","sxml":""}
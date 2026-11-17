-- liquibase formatted sql
-- changeset JOBTRACKER:1794948023967 stripComments:false  logicalFilePath:feat/ft-search-filter-lovs/jobtracker/views/ui_ft_salary_periods_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_ft_salary_periods_lov.sql:null:d9aae39b643e2d01104ceec4e5daf7822b981470:create

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


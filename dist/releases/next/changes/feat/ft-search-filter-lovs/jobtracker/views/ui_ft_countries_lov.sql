-- liquibase formatted sql
-- changeset JOBTRACKER:1794948023722 stripComments:false  logicalFilePath:feat/ft-search-filter-lovs/jobtracker/views/ui_ft_countries_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_ft_countries_lov.sql:null:53615cce62bdc95f5a2e1ae5c0e2e22eb1c0f8c2:create

create or replace force editionable view jobtracker.ui_ft_countries_lov (
    return_value,
    display_value
) as
    select
        country_code as return_value,
        country_name as display_value
    from
        jobtracker.ft_country_details
    where
        is_current
with read only;


-- liquibase formatted sql
-- changeset JOBTRACKER:1793700751723 stripComments:false  logicalFilePath:feat/company-read-views/jobtracker/views/ui_company_sizes_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_company_sizes_lov.sql:null:45c1de3477b66fda704f5c40d0389d2335cfadd4:create

create or replace force editionable view jobtracker.ui_company_sizes_lov (
    return_value,
    display_value,
    display_order
) as
    select
        company_size_id        as return_value,
        company_size_long_name as display_value,
        display_order
    from
        jobtracker.company_sizes
with read only;


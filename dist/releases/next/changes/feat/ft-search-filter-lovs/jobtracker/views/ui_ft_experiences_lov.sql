-- liquibase formatted sql
-- changeset JOBTRACKER:1794948023833 stripComments:false  logicalFilePath:feat/ft-search-filter-lovs/jobtracker/views/ui_ft_experiences_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_ft_experiences_lov.sql:null:47d89a934e2d529d08cb6c653216248450308a1e:create

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


-- liquibase formatted sql
-- changeset JOBTRACKER:1794948023748 stripComments:false  logicalFilePath:feat/ft-search-filter-lovs/jobtracker/views/ui_ft_continents_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_ft_continents_lov.sql:null:1e8aa4a371a5e841ba1f3a0cfdb1e54d144d4af8:create

create or replace force editionable view jobtracker.ui_ft_continents_lov (
    return_value,
    display_value
) as
    select
        continent_code as return_value,
        continent_name as display_value
    from
        jobtracker.ft_continent_details
    where
        is_current
with read only;


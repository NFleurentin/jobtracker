-- liquibase formatted sql
-- changeset JOBTRACKER:1794948023919 stripComments:false  logicalFilePath:feat/ft-search-filter-lovs/jobtracker/views/ui_ft_regions_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_ft_regions_lov.sql:null:d5aa861a62083c7ad9b9af2dcc93c69965f82bef:create

create or replace force editionable view jobtracker.ui_ft_regions_lov (
    return_value,
    display_value
) as
    select
        region_code as return_value,
        region_name as display_value
    from
        jobtracker.ft_region_details
    where
        is_current
with read only;


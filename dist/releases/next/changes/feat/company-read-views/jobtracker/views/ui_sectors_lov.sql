-- liquibase formatted sql
-- changeset JOBTRACKER:1793700751736 stripComments:false  logicalFilePath:feat/company-read-views/jobtracker/views/ui_sectors_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_sectors_lov.sql:null:389f8f98f88fa4d035356e06029144b3cb22666d:create

create or replace force editionable view jobtracker.ui_sectors_lov (
    return_value,
    display_value
) as
    select
        sector_id   as return_value,
        sector_name as display_value
    from
        jobtracker.sectors
with read only;


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


-- sqlcl_snapshot {"hash":"389f8f98f88fa4d035356e06029144b3cb22666d","type":"VIEW","name":"UI_SECTORS_LOV","schemaName":"JOBTRACKER","sxml":""}
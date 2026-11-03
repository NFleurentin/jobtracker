create or replace force editionable view jobtracker.ui_locations_lov (
    return_value,
    display_value
) as
    select
        location_id   as return_value,
        location_name as display_value
    from
        jobtracker.locations
with read only;


-- sqlcl_snapshot {"hash":"b28eee603380b8b56be0e4cda20479f3fcb1d8c0","type":"VIEW","name":"UI_LOCATIONS_LOV","schemaName":"JOBTRACKER","sxml":""}
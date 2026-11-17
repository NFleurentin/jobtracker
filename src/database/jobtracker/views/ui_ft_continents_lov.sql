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


-- sqlcl_snapshot {"hash":"1e8aa4a371a5e841ba1f3a0cfdb1e54d144d4af8","type":"VIEW","name":"UI_FT_CONTINENTS_LOV","schemaName":"JOBTRACKER","sxml":""}
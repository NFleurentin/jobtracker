create or replace force editionable view jobtracker.ui_sectors_lov (
    return_value,
    display_value
) as
    select
        sector_id as return_value,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                sector_name_en
            else
                sector_name
        end       as display_value
    from
        jobtracker.sectors
with read only;


-- sqlcl_snapshot {"hash":"82fd741d96f58fdd9913d90a6ce24f122c3304bd","type":"VIEW","name":"UI_SECTORS_LOV","schemaName":"JOBTRACKER","sxml":""}
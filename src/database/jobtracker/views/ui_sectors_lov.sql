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
                sector_name_fr
        end       as display_value
    from
        jobtracker.sectors
with read only;


-- sqlcl_snapshot {"hash":"19c4f2566181b4b3d40b9f7b277d4f52c41c69d9","type":"VIEW","name":"UI_SECTORS_LOV","schemaName":"JOBTRACKER","sxml":""}
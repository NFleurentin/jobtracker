-- liquibase formatted sql
-- changeset JOBTRACKER:1793723863050 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/views/ui_sectors_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_sectors_lov.sql:389f8f98f88fa4d035356e06029144b3cb22666d:82fd741d96f58fdd9913d90a6ce24f122c3304bd:alter

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


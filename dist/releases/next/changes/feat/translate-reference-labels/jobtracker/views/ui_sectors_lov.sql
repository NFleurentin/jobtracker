-- liquibase formatted sql
-- changeset JOBTRACKER:1793724733495 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/views/ui_sectors_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_sectors_lov.sql:389f8f98f88fa4d035356e06029144b3cb22666d:19c4f2566181b4b3d40b9f7b277d4f52c41c69d9:alter

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


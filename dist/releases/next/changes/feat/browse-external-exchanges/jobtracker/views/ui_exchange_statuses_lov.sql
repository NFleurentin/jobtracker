-- liquibase formatted sql
-- changeset JOBTRACKER:1794510057506 stripComments:false  logicalFilePath:feat/browse-external-exchanges/jobtracker/views/ui_exchange_statuses_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_exchange_statuses_lov.sql:null:d94278a1782405d860f7ea54f70982fb24486e92:create

create or replace force editionable view jobtracker.ui_exchange_statuses_lov (
    return_value,
    display_value
) as
    select
        exchange_status_id as return_value,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                exchange_status_name_en
            else
                exchange_status_name_fr
        end                as display_value
    from
        jobtracker.exchange_statuses
with read only;


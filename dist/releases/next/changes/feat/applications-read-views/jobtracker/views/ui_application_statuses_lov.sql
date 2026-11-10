-- liquibase formatted sql
-- changeset JOBTRACKER:1794302514241 stripComments:false  logicalFilePath:feat/applications-read-views/jobtracker/views/ui_application_statuses_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_application_statuses_lov.sql:null:66f00986a40a6e387aa9e9c0d48fc14516167213:create

create or replace force editionable view jobtracker.ui_application_statuses_lov (
    return_value,
    display_value,
    display_order
) as
    select
        application_status_id as return_value,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                application_status_name_en
            else
                application_status_name_fr
        end                   as display_value,
        display_order
    from
        jobtracker.application_statuses
with read only;


-- liquibase formatted sql
-- changeset JOBTRACKER:1794510057524 stripComments:false  logicalFilePath:feat/browse-external-exchanges/jobtracker/views/ui_external_systems_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_external_systems_lov.sql:null:fc9e6111c12d8f36b54e7691a719340cd71c9839:create

create or replace force editionable view jobtracker.ui_external_systems_lov (
    return_value,
    display_value
) as
    select
        external_system_id as return_value,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                external_system_name_en
            else
                external_system_name_fr
        end                as display_value
    from
        jobtracker.external_systems
with read only;


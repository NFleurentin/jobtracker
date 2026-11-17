-- liquibase formatted sql
-- changeset JOBTRACKER:1794901005391 stripComments:false  logicalFilePath:feat/external-systems-settings/jobtracker/package_bodies/external_system_api.sql
-- sqlcl_snapshot src/database/jobtracker/package_bodies/external_system_api.sql:null:5cbb80cce2a44c65ef137973a08a08d22e72115c:create

create or replace package body jobtracker.external_system_api is

    procedure update_external_system (
        in_external_system_id   in external_systems.external_system_id%type,
        in_retention_days       in external_systems.retention_days%type,
        in_orphan_delay_minutes in external_systems.orphan_delay_minutes%type,
        in_is_exchange_logged   in external_systems.is_exchange_logged%type
    ) is
    begin
        update external_systems
        set
            retention_days = in_retention_days,
            orphan_delay_minutes = in_orphan_delay_minutes,
            is_exchange_logged = in_is_exchange_logged
        where
            external_system_id = in_external_system_id;

        if sql%rowcount = 0 then
            raise_application_error(app_errors.co_not_found, 'Unknown external system: ' || in_external_system_id);
        end if;

    end update_external_system;

end external_system_api;
/


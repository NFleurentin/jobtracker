-- liquibase formatted sql
-- changeset JOBTRACKER:1794246056078 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/tables/application_status_changes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/application_status_changes.sql:null:24fca45149d1e10ccdc1fec08f7f6ae6c4bdc55f:create

create table jobtracker.application_status_changes (
    application_status_change_id number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache
    20 noorder nocycle nokeep noscale not null enable,
    application_id               number not null enable,
    application_status_id        number not null enable,
    changed_at                   timestamp(6) with time zone default systimestamp not null enable,
    note_text                    clob
);

-- changeset JOBTRACKER:1794246056102 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/tables/application_status_changes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/application_status_changes.sql:null:ea2e2b5dddd5aa91885e4981cbd335aa11c786e2:create

alter table jobtracker.application_status_changes
    add constraint application_status_changes_pk primary key ( application_status_change_id )
        using index enable;


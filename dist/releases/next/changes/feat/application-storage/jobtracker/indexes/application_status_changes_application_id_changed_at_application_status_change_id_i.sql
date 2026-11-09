-- liquibase formatted sql
-- changeset JOBTRACKER:1794246056065 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/indexes/application_status_changes_application_id_changed_at_application_status_change_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/application_status_changes_application_id_changed_at_application_status_change_id_i.sql:null:db3f12ff83d9f1aa9b5b56d05b423fe57c987226:create

create index jobtracker.application_status_changes_application_id_changed_at_application_status_change_id_i on
    jobtracker.application_status_changes (
        application_id,
    sys_extract_utc(changed_at),
        application_status_change_id
    );


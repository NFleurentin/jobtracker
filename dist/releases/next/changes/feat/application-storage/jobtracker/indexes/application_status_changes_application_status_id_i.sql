-- liquibase formatted sql
-- changeset JOBTRACKER:1794246056071 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/indexes/application_status_changes_application_status_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/application_status_changes_application_status_id_i.sql:null:8d578b1105f9f44f31de0ddf4bb72eb286c882ec:create

create index jobtracker.application_status_changes_application_status_id_i on
    jobtracker.application_status_changes (
        application_status_id
    );


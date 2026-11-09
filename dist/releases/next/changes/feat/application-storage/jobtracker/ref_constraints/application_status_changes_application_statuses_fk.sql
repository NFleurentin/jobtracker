-- liquibase formatted sql
-- changeset JOBTRACKER:1794246056084 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/ref_constraints/application_status_changes_application_statuses_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/application_status_changes_application_statuses_fk.sql:null:25aad0bfcb252e899900d50a0c02f5ace735cfb5:create

alter table jobtracker.application_status_changes
    add constraint application_status_changes_application_statuses_fk
        foreign key ( application_status_id )
            references jobtracker.application_statuses ( application_status_id )
        enable;


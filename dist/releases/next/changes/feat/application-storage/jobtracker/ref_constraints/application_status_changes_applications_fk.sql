-- liquibase formatted sql
-- changeset JOBTRACKER:1794246056069 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/ref_constraints/application_status_changes_applications_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/application_status_changes_applications_fk.sql:null:6de34ae67657b66e6ec3b51fa38239aec1b5fba2:create

alter table jobtracker.application_status_changes
    add constraint application_status_changes_applications_fk
        foreign key ( application_id )
            references jobtracker.applications ( application_id )
                on delete cascade
        enable;


-- liquibase formatted sql
-- changeset JOBTRACKER:1794246056097 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/ref_constraints/applications_application_types_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/applications_application_types_fk.sql:null:13a4f7910ba3058549b8518c597bb481fec9e9a9:create

alter table jobtracker.applications
    add constraint applications_application_types_fk
        foreign key ( application_type_id )
            references jobtracker.application_types ( application_type_id )
        enable;


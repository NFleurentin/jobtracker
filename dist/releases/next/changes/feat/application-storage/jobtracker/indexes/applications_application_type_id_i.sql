-- liquibase formatted sql
-- changeset JOBTRACKER:1794246056074 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/indexes/applications_application_type_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/applications_application_type_id_i.sql:null:09f29c199377a481f95d78570fb4129766d7849f:create

create index jobtracker.applications_application_type_id_i on
    jobtracker.applications (
        application_type_id
    );


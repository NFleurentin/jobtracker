-- liquibase formatted sql
-- changeset JOBTRACKER:1794246056081 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/indexes/applications_company_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/applications_company_id_i.sql:null:01b5f73ce5b72c3263e1e66f4b30ba25103b73be:create

create index jobtracker.applications_company_id_i on
    jobtracker.applications (
        company_id
    );


-- liquibase formatted sql
-- changeset JOBTRACKER:1793628811877 stripComments:false  logicalFilePath:feat/company-management/jobtracker/indexes/companies_location_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/companies_location_id_i.sql:null:7b00500c3f0f475345ce8a306ccf4b47c5247461:create

create index jobtracker.companies_location_id_i on
    jobtracker.companies (
        location_id
    );


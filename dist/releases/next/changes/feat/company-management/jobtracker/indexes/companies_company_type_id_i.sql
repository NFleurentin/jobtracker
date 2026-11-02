-- liquibase formatted sql
-- changeset JOBTRACKER:1793628811870 stripComments:false  logicalFilePath:feat/company-management/jobtracker/indexes/companies_company_type_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/companies_company_type_id_i.sql:null:054902dfca44b2cb24152887009f731e5d9094ee:create

create index jobtracker.companies_company_type_id_i on
    jobtracker.companies (
        company_type_id
    );


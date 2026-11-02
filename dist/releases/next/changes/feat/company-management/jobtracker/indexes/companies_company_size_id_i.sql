-- liquibase formatted sql
-- changeset JOBTRACKER:1793628811867 stripComments:false  logicalFilePath:feat/company-management/jobtracker/indexes/companies_company_size_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/companies_company_size_id_i.sql:null:184c462a00fa43fb23793788538790f7c49d49c9:create

create index jobtracker.companies_company_size_id_i on
    jobtracker.companies (
        company_size_id
    );


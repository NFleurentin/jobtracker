-- liquibase formatted sql
-- changeset JOBTRACKER:1793628811881 stripComments:false  logicalFilePath:feat/company-management/jobtracker/indexes/companies_parent_company_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/companies_parent_company_id_i.sql:null:c17b3cff47a5384eefbae715e379beae7ccf6442:create

create index jobtracker.companies_parent_company_id_i on
    jobtracker.companies (
        parent_company_id
    );


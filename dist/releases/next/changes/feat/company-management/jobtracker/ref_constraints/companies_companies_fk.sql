-- liquibase formatted sql
-- changeset JOBTRACKER:1793628811887 stripComments:false  logicalFilePath:feat/company-management/jobtracker/ref_constraints/companies_companies_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/companies_companies_fk.sql:null:e9fa0f97b44fceb2db5ea08ffe44b47798f0b804:create

alter table jobtracker.companies
    add constraint companies_companies_fk
        foreign key ( parent_company_id )
            references jobtracker.companies ( company_id )
        enable;


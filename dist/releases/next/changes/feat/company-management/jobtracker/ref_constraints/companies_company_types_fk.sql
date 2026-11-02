-- liquibase formatted sql
-- changeset JOBTRACKER:1793628811894 stripComments:false  logicalFilePath:feat/company-management/jobtracker/ref_constraints/companies_company_types_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/companies_company_types_fk.sql:null:bad8c77e937e67ca446f8bfa808b1b1cd29e3504:create

alter table jobtracker.companies
    add constraint companies_company_types_fk
        foreign key ( company_type_id )
            references jobtracker.company_types ( company_type_id )
        enable;


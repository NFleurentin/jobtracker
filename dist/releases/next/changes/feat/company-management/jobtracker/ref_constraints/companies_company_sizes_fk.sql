-- liquibase formatted sql
-- changeset JOBTRACKER:1793628811897 stripComments:false  logicalFilePath:feat/company-management/jobtracker/ref_constraints/companies_company_sizes_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/companies_company_sizes_fk.sql:null:5d88daf78e725a384ddf2245077c2d980b21682d:create

alter table jobtracker.companies
    add constraint companies_company_sizes_fk
        foreign key ( company_size_id )
            references jobtracker.company_sizes ( company_size_id )
        enable;


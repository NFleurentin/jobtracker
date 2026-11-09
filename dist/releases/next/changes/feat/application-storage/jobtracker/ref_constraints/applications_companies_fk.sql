-- liquibase formatted sql
-- changeset JOBTRACKER:1794246056062 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/ref_constraints/applications_companies_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/applications_companies_fk.sql:null:1afd4ba3b4106147e6333dab70564943f331cb86:create

alter table jobtracker.applications
    add constraint applications_companies_fk
        foreign key ( company_id )
            references jobtracker.companies ( company_id )
        enable;


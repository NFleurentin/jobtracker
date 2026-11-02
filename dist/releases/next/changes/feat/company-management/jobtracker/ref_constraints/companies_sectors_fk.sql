-- liquibase formatted sql
-- changeset JOBTRACKER:1793628811900 stripComments:false  logicalFilePath:feat/company-management/jobtracker/ref_constraints/companies_sectors_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/companies_sectors_fk.sql:null:f91782b17b458dddd42d9dde0830987dc3934ade:create

alter table jobtracker.companies
    add constraint companies_sectors_fk
        foreign key ( sector_id )
            references jobtracker.sectors ( sector_id )
        enable;


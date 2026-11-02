-- liquibase formatted sql
-- changeset JOBTRACKER:1793628811891 stripComments:false  logicalFilePath:feat/company-management/jobtracker/ref_constraints/companies_locations_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/companies_locations_fk.sql:null:354d1036ebc52ed398e1d6a47c3d0e86a254bc04:create

alter table jobtracker.companies
    add constraint companies_locations_fk
        foreign key ( location_id )
            references jobtracker.locations ( location_id )
        enable;


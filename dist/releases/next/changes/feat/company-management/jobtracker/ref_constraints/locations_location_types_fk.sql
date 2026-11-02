-- liquibase formatted sql
-- changeset JOBTRACKER:1793628055917 stripComments:false  logicalFilePath:feat/company-management/jobtracker/ref_constraints/locations_location_types_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/locations_location_types_fk.sql:null:be4ab3dd4560076a338da0d941b2c3f98a909d7d:create

alter table jobtracker.locations
    add constraint locations_location_types_fk
        foreign key ( location_type_id )
            references jobtracker.location_types ( location_type_id )
        enable;


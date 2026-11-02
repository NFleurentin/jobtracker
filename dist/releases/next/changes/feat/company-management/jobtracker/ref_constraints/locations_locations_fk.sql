-- liquibase formatted sql
-- changeset JOBTRACKER:1793628055920 stripComments:false  logicalFilePath:feat/company-management/jobtracker/ref_constraints/locations_locations_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/locations_locations_fk.sql:null:6f3e9f1a52eaef21e61056dfe5cb7d9107221e30:create

alter table jobtracker.locations
    add constraint locations_locations_fk
        foreign key ( parent_location_id )
            references jobtracker.locations ( location_id )
        enable;


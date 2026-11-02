-- liquibase formatted sql
-- changeset JOBTRACKER:1793628055912 stripComments:false  logicalFilePath:feat/company-management/jobtracker/indexes/locations_location_type_id_location_code_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/locations_location_type_id_location_code_i.sql:null:3b1aa615e8963cfb41e2135ed5ab86f25ebb3821:create

create index jobtracker.locations_location_type_id_location_code_i on
    jobtracker.locations (
        location_type_id,
        location_code
    );


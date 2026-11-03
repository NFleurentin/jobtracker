-- liquibase formatted sql
-- changeset JOBTRACKER:1793725877747 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:040f8b0dff79db021ec731a3b810568a3e544a26:d9f0f931c1049730795f47f599351075f732a27e:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."LOCATION_TYPES" DROP ("LOCATION_TYPE_NAME")
/
*/

-- changeset JOBTRACKER:1793725877760 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:040f8b0dff79db021ec731a3b810568a3e544a26:4758eff0dede8d7c9c74fcfdd3b7c5e040034c07:alter

alter table jobtracker.location_types modify (
    location_type_name_en not null enable
)
/

-- changeset JOBTRACKER:1793725877775 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:040f8b0dff79db021ec731a3b810568a3e544a26:94566106623e3066032a3dae7fec5d12f5a0e0e5:alter

alter table jobtracker.location_types modify (
    location_type_name_fr not null enable
)
/

-- changeset JOBTRACKER:1793725877789 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:040f8b0dff79db021ec731a3b810568a3e544a26:7a6cef645756b6bb90674be48ab2af35919ebf60:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."LOCATION_TYPES" DROP CONSTRAINT "LOCATION_TYPES_LOCATION_TYPE_NAME_UK"
/
*/


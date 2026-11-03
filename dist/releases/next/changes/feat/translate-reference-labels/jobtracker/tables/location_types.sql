-- liquibase formatted sql
-- changeset JOBTRACKER:1793723375475 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:a996350b37f3895cf8dcbb6d6da571864e7ea37f:3489df4a3ab1b5a82e217ebfc36a0a88ba998345:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_tab_columns where table_name = 'LOCATION_TYPES' and column_name = 'LOCATION_TYPE_NAME_FR'

alter table jobtracker.location_types add (
    location_type_name_fr varchar2(100 char) not null enable
)
/

-- changeset JOBTRACKER:1793723375490 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:a996350b37f3895cf8dcbb6d6da571864e7ea37f:e792c8357cfc4f84854b5b40e5f91d9c6bbf37e7:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_tab_columns where table_name = 'LOCATION_TYPES' and column_name = 'LOCATION_TYPE_NAME_EN'

alter table jobtracker.location_types add (
    location_type_name_en varchar2(100 char) not null enable
)
/

-- changeset JOBTRACKER:1793723375499 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:a996350b37f3895cf8dcbb6d6da571864e7ea37f:d9f0f931c1049730795f47f599351075f732a27e:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."LOCATION_TYPES" DROP ("LOCATION_TYPE_NAME")
/
*/

-- changeset JOBTRACKER:1793723375507 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:a996350b37f3895cf8dcbb6d6da571864e7ea37f:7a6cef645756b6bb90674be48ab2af35919ebf60:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."LOCATION_TYPES" DROP CONSTRAINT "LOCATION_TYPES_LOCATION_TYPE_NAME_UK"
/
*/

-- changeset JOBTRACKER:1793723375517 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:a996350b37f3895cf8dcbb6d6da571864e7ea37f:acb0eeac172f5c981a5c7c5304b09554b39cc9a0:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_constraints where table_name = 'LOCATION_TYPES' and constraint_name = 'LOCATION_TYPES_LOCATION_TYPE_NAME_FR_UK'

alter table jobtracker.location_types add constraint location_types_location_type_name_fr_uk unique ( location_type_name_fr )
    using index enable
/

-- changeset JOBTRACKER:1793723375528 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:a996350b37f3895cf8dcbb6d6da571864e7ea37f:922b51755a3267f11b3317130f6880d75f03686d:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_constraints where table_name = 'LOCATION_TYPES' and constraint_name = 'LOCATION_TYPES_LOCATION_TYPE_NAME_EN_UK'

alter table jobtracker.location_types add constraint location_types_location_type_name_en_uk unique ( location_type_name_en )
    using index enable
/


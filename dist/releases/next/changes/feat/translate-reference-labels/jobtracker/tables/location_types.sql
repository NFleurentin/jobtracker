-- liquibase formatted sql
-- changeset JOBTRACKER:1793723863242 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:a996350b37f3895cf8dcbb6d6da571864e7ea37f:9810fbc6ca2736b1d9b84fdfe8b1be5c10fa7d9a:alter

alter table jobtracker.location_types add (
    location_type_name_en varchar2(100 char)
)
/

-- changeset JOBTRACKER:1793723863255 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:a996350b37f3895cf8dcbb6d6da571864e7ea37f:922b51755a3267f11b3317130f6880d75f03686d:alter

alter table jobtracker.location_types add constraint location_types_location_type_name_en_uk unique ( location_type_name_en )
    using index enable
/


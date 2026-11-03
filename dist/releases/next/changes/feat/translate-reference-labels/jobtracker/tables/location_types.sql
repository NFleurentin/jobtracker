-- liquibase formatted sql
-- changeset JOBTRACKER:1793724733664 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:a996350b37f3895cf8dcbb6d6da571864e7ea37f:9810fbc6ca2736b1d9b84fdfe8b1be5c10fa7d9a:alter

alter table jobtracker.location_types add (
    location_type_name_en varchar2(100 char)
)
/

-- changeset JOBTRACKER:1793724733676 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:a996350b37f3895cf8dcbb6d6da571864e7ea37f:50a3c4336f1256c2a01b71a337fc2460f1f5d410:alter

alter table jobtracker.location_types add (
    location_type_name_fr varchar2(100 char)
)
/

-- changeset JOBTRACKER:1793724733688 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:a996350b37f3895cf8dcbb6d6da571864e7ea37f:acb0eeac172f5c981a5c7c5304b09554b39cc9a0:alter

alter table jobtracker.location_types add constraint location_types_location_type_name_fr_uk unique ( location_type_name_fr )
    using index enable
/

-- changeset JOBTRACKER:1793724733702 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:a996350b37f3895cf8dcbb6d6da571864e7ea37f:922b51755a3267f11b3317130f6880d75f03686d:alter

alter table jobtracker.location_types add constraint location_types_location_type_name_en_uk unique ( location_type_name_en )
    using index enable
/


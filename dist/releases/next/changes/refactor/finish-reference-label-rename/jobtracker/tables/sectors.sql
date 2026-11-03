-- liquibase formatted sql
-- changeset JOBTRACKER:1793725877754 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/sectors.sql
-- sqlcl_snapshot src/database/jobtracker/tables/sectors.sql:0cb1d7d1561d2db0cb32358385e0df19a85ce7b6:841efe2dc973e612f63d5cf35cbe961a29a293da:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."SECTORS" DROP ("SECTOR_NAME")
/
*/

-- changeset JOBTRACKER:1793725877771 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/sectors.sql
-- sqlcl_snapshot src/database/jobtracker/tables/sectors.sql:0cb1d7d1561d2db0cb32358385e0df19a85ce7b6:369a603f56b5f039a8abcb7b7295ec0fca0e1e8b:alter

alter table jobtracker.sectors modify (
    sector_name_en not null enable
)
/

-- changeset JOBTRACKER:1793725877787 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/sectors.sql
-- sqlcl_snapshot src/database/jobtracker/tables/sectors.sql:0cb1d7d1561d2db0cb32358385e0df19a85ce7b6:3dbcaaeeff53da78af9d7b2b5892196fa5ba86c6:alter

alter table jobtracker.sectors modify (
    sector_name_fr not null enable
)
/

-- changeset JOBTRACKER:1793725877798 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/sectors.sql
-- sqlcl_snapshot src/database/jobtracker/tables/sectors.sql:0cb1d7d1561d2db0cb32358385e0df19a85ce7b6:6c45065c93725d2a2fd1fda591415616cd54f886:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."SECTORS" DROP CONSTRAINT "SECTORS_SECTOR_NAME_UK"
/
*/


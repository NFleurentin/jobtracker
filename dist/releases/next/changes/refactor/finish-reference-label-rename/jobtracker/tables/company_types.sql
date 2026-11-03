-- liquibase formatted sql
-- changeset JOBTRACKER:1793725877749 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:8891a27e7dbe9f023a27932932eee7ad8b172461:61c7bfcfd3ecbcac84d45a3872bee8a38b0dbd67:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."COMPANY_TYPES" DROP ("COMPANY_TYPE_NAME")
/
*/

-- changeset JOBTRACKER:1793725877765 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:8891a27e7dbe9f023a27932932eee7ad8b172461:78af3eafc47ab3fd72d2e45049dfee575f61e6e0:alter

alter table jobtracker.company_types modify (
    company_type_name_en not null enable
)
/

-- changeset JOBTRACKER:1793725877779 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:8891a27e7dbe9f023a27932932eee7ad8b172461:9a2e4abe91b905d5cbcf29fdb82084b16366619d:alter

alter table jobtracker.company_types modify (
    company_type_name_fr not null enable
)
/

-- changeset JOBTRACKER:1793725877791 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:8891a27e7dbe9f023a27932932eee7ad8b172461:541025675e14165b24de3d4152300c0ee04b928a:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."COMPANY_TYPES" DROP CONSTRAINT "COMPANY_TYPES_COMPANY_TYPE_NAME_UK"
/
*/


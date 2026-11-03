-- liquibase formatted sql
-- changeset JOBTRACKER:1793723375472 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:68a723c463951606c3690a2fbc72f338ed58a647:83b20eddfac575adaeb1c67703831e641c55ddac:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_tab_columns where table_name = 'COMPANY_TYPES' and column_name = 'COMPANY_TYPE_NAME_FR'

alter table jobtracker.company_types add (
    company_type_name_fr varchar2(100 char) not null enable
)
/

-- changeset JOBTRACKER:1793723375487 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:68a723c463951606c3690a2fbc72f338ed58a647:251857f2630ade102843ca0d1c722a98327d2fb4:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_tab_columns where table_name = 'COMPANY_TYPES' and column_name = 'COMPANY_TYPE_NAME_EN'

alter table jobtracker.company_types add (
    company_type_name_en varchar2(100 char) not null enable
)
/

-- changeset JOBTRACKER:1793723375498 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:68a723c463951606c3690a2fbc72f338ed58a647:61c7bfcfd3ecbcac84d45a3872bee8a38b0dbd67:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."COMPANY_TYPES" DROP ("COMPANY_TYPE_NAME")
/
*/

-- changeset JOBTRACKER:1793723375505 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:68a723c463951606c3690a2fbc72f338ed58a647:541025675e14165b24de3d4152300c0ee04b928a:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."COMPANY_TYPES" DROP CONSTRAINT "COMPANY_TYPES_COMPANY_TYPE_NAME_UK"
/
*/

-- changeset JOBTRACKER:1793723375514 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:68a723c463951606c3690a2fbc72f338ed58a647:2fabe6987bb30866ba2e5b354f299b67dc9d5eef:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_constraints where table_name = 'COMPANY_TYPES' and constraint_name = 'COMPANY_TYPES_COMPANY_TYPE_NAME_EN_UK'

alter table jobtracker.company_types add constraint company_types_company_type_name_en_uk unique ( company_type_name_en )
    using index enable
/

-- changeset JOBTRACKER:1793723375525 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:68a723c463951606c3690a2fbc72f338ed58a647:ec7f2c8e6972823afdbbd40d00d513b70a9bc524:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_constraints where table_name = 'COMPANY_TYPES' and constraint_name = 'COMPANY_TYPES_COMPANY_TYPE_NAME_FR_UK'

alter table jobtracker.company_types add constraint company_types_company_type_name_fr_uk unique ( company_type_name_fr )
    using index enable
/


-- liquibase formatted sql
-- changeset JOBTRACKER:1793723375469 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:8b9b49e2f4790000d53905998f42b2da9cbcc0aa:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_tab_columns where table_name = 'COMPANY_SIZES' and column_name = 'COMPANY_SIZE_SHORT_NAME_FR'

alter table jobtracker.company_sizes add (
    company_size_short_name_fr varchar2(10 char) not null enable
)
/

-- changeset JOBTRACKER:1793723375481 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:e456e2bfdbf40e51fb36169b981176fa7131ca2a:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_tab_columns where table_name = 'COMPANY_SIZES' and column_name = 'COMPANY_SIZE_LONG_NAME_FR'

alter table jobtracker.company_sizes add (
    company_size_long_name_fr varchar2(100 char) not null enable
)
/

-- changeset JOBTRACKER:1793723375496 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:e12583c7e2362a2bf1a99bbff8445928e728bff1:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_tab_columns where table_name = 'COMPANY_SIZES' and column_name = 'COMPANY_SIZE_SHORT_NAME_EN'

alter table jobtracker.company_sizes add (
    company_size_short_name_en varchar2(10 char) not null enable
)
/

-- changeset JOBTRACKER:1793723375504 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:753a203dd4f47ba0b7a987916aabf2f80d4bcd71:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_tab_columns where table_name = 'COMPANY_SIZES' and column_name = 'COMPANY_SIZE_LONG_NAME_EN'

alter table jobtracker.company_sizes add (
    company_size_long_name_en varchar2(100 char) not null enable
)
/

-- changeset JOBTRACKER:1793723375512 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:60c5bcefca578cf2e5d5dc693ca4298a58c1ee20:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."COMPANY_SIZES" DROP ("COMPANY_SIZE_SHORT_NAME")
/
*/

-- changeset JOBTRACKER:1793723375522 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:99475d896f71401551985c85f48e139eb31cacc4:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."COMPANY_SIZES" DROP ("COMPANY_SIZE_LONG_NAME")
/
*/

-- changeset JOBTRACKER:1793723375529 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:72f5b7aec81e5c4852075ebba506627bfdd9f093:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."COMPANY_SIZES" DROP CONSTRAINT "COMPANY_SIZES_COMPANY_SIZE_SHORT_NAME_UK"
/
*/

-- changeset JOBTRACKER:1793723375532 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:6ed8868554db816a68f0bc2be282b480c13b826e:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."COMPANY_SIZES" DROP CONSTRAINT "COMPANY_SIZES_COMPANY_SIZE_LONG_NAME_UK"
/
*/

-- changeset JOBTRACKER:1793723375535 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:38c845c82d68ecefac68869812d4234163d1fe10:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_constraints where table_name = 'COMPANY_SIZES' and constraint_name = 'COMPANY_SIZES_COMPANY_SIZE_SHORT_NAME_EN_UK'

alter table jobtracker.company_sizes add constraint company_sizes_company_size_short_name_en_uk unique ( company_size_short_name_en )
    using index enable
/

-- changeset JOBTRACKER:1793723375539 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:73c9b820a55d80adcedb8a5f3ee882d1b8b271a0:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_constraints where table_name = 'COMPANY_SIZES' and constraint_name = 'COMPANY_SIZES_COMPANY_SIZE_LONG_NAME_EN_UK'

alter table jobtracker.company_sizes add constraint company_sizes_company_size_long_name_en_uk unique ( company_size_long_name_en )
    using index enable
/

-- changeset JOBTRACKER:1793723375542 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:5a7e7d4b5d54201589da825909f477c5337424e6:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_constraints where table_name = 'COMPANY_SIZES' and constraint_name = 'COMPANY_SIZES_COMPANY_SIZE_SHORT_NAME_FR_UK'

alter table jobtracker.company_sizes add constraint company_sizes_company_size_short_name_fr_uk unique ( company_size_short_name_fr )
    using index enable
/

-- changeset JOBTRACKER:1793723375545 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:c597e21b80086902571bedbbea85ab991e5d50ee:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_constraints where table_name = 'COMPANY_SIZES' and constraint_name = 'COMPANY_SIZES_COMPANY_SIZE_LONG_NAME_FR_UK'

alter table jobtracker.company_sizes add constraint company_sizes_company_size_long_name_fr_uk unique ( company_size_long_name_fr )
    using index enable
/


-- liquibase formatted sql
-- changeset JOBTRACKER:1793723375465 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/sectors.sql
-- sqlcl_snapshot src/database/jobtracker/tables/sectors.sql:49541f3519c71b4125b117e0bbb7d3edd770e167:02299e453e1ef1e5084e771c59fccecf16b467db:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_tab_columns where table_name = 'SECTORS' and column_name = 'SECTOR_NAME_FR'

alter table jobtracker.sectors add (
    sector_name_fr varchar2(100 char) not null enable
)
/

-- changeset JOBTRACKER:1793723375478 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/sectors.sql
-- sqlcl_snapshot src/database/jobtracker/tables/sectors.sql:49541f3519c71b4125b117e0bbb7d3edd770e167:2cd1e4403286425a2d0a71d21e5a36f5fa3bde41:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_tab_columns where table_name = 'SECTORS' and column_name = 'SECTOR_NAME_EN'

alter table jobtracker.sectors add (
    sector_name_en varchar2(100 char) not null enable
)
/

-- changeset JOBTRACKER:1793723375492 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/sectors.sql
-- sqlcl_snapshot src/database/jobtracker/tables/sectors.sql:49541f3519c71b4125b117e0bbb7d3edd770e167:841efe2dc973e612f63d5cf35cbe961a29a293da:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."SECTORS" DROP ("SECTOR_NAME")
/
*/

-- changeset JOBTRACKER:1793723375501 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/sectors.sql
-- sqlcl_snapshot src/database/jobtracker/tables/sectors.sql:49541f3519c71b4125b117e0bbb7d3edd770e167:6c45065c93725d2a2fd1fda591415616cd54f886:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."SECTORS" DROP CONSTRAINT "SECTORS_SECTOR_NAME_UK"
/
*/

-- changeset JOBTRACKER:1793723375510 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/sectors.sql
-- sqlcl_snapshot src/database/jobtracker/tables/sectors.sql:49541f3519c71b4125b117e0bbb7d3edd770e167:f2ca520aa5db169427383dcf42a239e11fc894cf:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_constraints where table_name = 'SECTORS' and constraint_name = 'SECTORS_SECTOR_NAME_FR_UK'

alter table jobtracker.sectors add constraint sectors_sector_name_fr_uk unique ( sector_name_fr )
    using index enable
/

-- changeset JOBTRACKER:1793723375520 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/sectors.sql
-- sqlcl_snapshot src/database/jobtracker/tables/sectors.sql:49541f3519c71b4125b117e0bbb7d3edd770e167:09421598eb9bd7d42541bac51ef78e1c0d516b4b:alter
-- preconditions onFail:MARK_RAN
-- precondition-sql-check expectedResult:0 select count(*) from user_constraints where table_name = 'SECTORS' and constraint_name = 'SECTORS_SECTOR_NAME_EN_UK'

alter table jobtracker.sectors add constraint sectors_sector_name_en_uk unique ( sector_name_en )
    using index enable
/


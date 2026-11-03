-- liquibase formatted sql
-- changeset JOBTRACKER:1793723863233 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/sectors.sql
-- sqlcl_snapshot src/database/jobtracker/tables/sectors.sql:49541f3519c71b4125b117e0bbb7d3edd770e167:a7f507ab4da7d9600647ccdd67c4e7e0019cf784:alter

alter table jobtracker.sectors add (
    sector_name_en varchar2(100 char)
)
/

-- changeset JOBTRACKER:1793723863246 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/sectors.sql
-- sqlcl_snapshot src/database/jobtracker/tables/sectors.sql:49541f3519c71b4125b117e0bbb7d3edd770e167:09421598eb9bd7d42541bac51ef78e1c0d516b4b:alter

alter table jobtracker.sectors add constraint sectors_sector_name_en_uk unique ( sector_name_en )
    using index enable
/


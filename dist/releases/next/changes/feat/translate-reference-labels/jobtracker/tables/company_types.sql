-- liquibase formatted sql
-- changeset JOBTRACKER:1793724733671 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:68a723c463951606c3690a2fbc72f338ed58a647:4bccb01b603afe2d6ce7454def4a8d1ff582dfd5:alter

alter table jobtracker.company_types add (
    company_type_name_en varchar2(100 char)
)
/

-- changeset JOBTRACKER:1793724733682 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:68a723c463951606c3690a2fbc72f338ed58a647:070ac0c6894043c27a548e412b9395cdbbecdb6a:alter

alter table jobtracker.company_types add (
    company_type_name_fr varchar2(100 char)
)
/

-- changeset JOBTRACKER:1793724733695 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:68a723c463951606c3690a2fbc72f338ed58a647:ec7f2c8e6972823afdbbd40d00d513b70a9bc524:alter

alter table jobtracker.company_types add constraint company_types_company_type_name_fr_uk unique ( company_type_name_fr )
    using index enable
/

-- changeset JOBTRACKER:1793724733707 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:68a723c463951606c3690a2fbc72f338ed58a647:2fabe6987bb30866ba2e5b354f299b67dc9d5eef:alter

alter table jobtracker.company_types add constraint company_types_company_type_name_en_uk unique ( company_type_name_en )
    using index enable
/


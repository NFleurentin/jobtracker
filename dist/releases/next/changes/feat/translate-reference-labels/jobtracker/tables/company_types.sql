-- liquibase formatted sql
-- changeset JOBTRACKER:1793723863236 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:68a723c463951606c3690a2fbc72f338ed58a647:4bccb01b603afe2d6ce7454def4a8d1ff582dfd5:alter

alter table jobtracker.company_types add (
    company_type_name_en varchar2(100 char)
)
/

-- changeset JOBTRACKER:1793723863249 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:68a723c463951606c3690a2fbc72f338ed58a647:2fabe6987bb30866ba2e5b354f299b67dc9d5eef:alter

alter table jobtracker.company_types add constraint company_types_company_type_name_en_uk unique ( company_type_name_en )
    using index enable
/


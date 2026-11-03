-- liquibase formatted sql
-- changeset JOBTRACKER:1793723863240 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:400b8714339fbdf94d99318a8ffb363a436ac60d:alter

alter table jobtracker.company_sizes add (
    company_size_short_name_en varchar2(10 char)
)
/

-- changeset JOBTRACKER:1793723863252 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:595dddbb163e6d403cf2f5ee8fe2e6e31997027a:alter

alter table jobtracker.company_sizes add (
    company_size_long_name_en varchar2(100 char)
)
/

-- changeset JOBTRACKER:1793723863258 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:38c845c82d68ecefac68869812d4234163d1fe10:alter

alter table jobtracker.company_sizes add constraint company_sizes_company_size_short_name_en_uk unique ( company_size_short_name_en )
    using index enable
/

-- changeset JOBTRACKER:1793723863262 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:73c9b820a55d80adcedb8a5f3ee882d1b8b271a0:alter

alter table jobtracker.company_sizes add constraint company_sizes_company_size_long_name_en_uk unique ( company_size_long_name_en )
    using index enable
/


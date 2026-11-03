-- liquibase formatted sql
-- changeset JOBTRACKER:1793724733668 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:400b8714339fbdf94d99318a8ffb363a436ac60d:alter

alter table jobtracker.company_sizes add (
    company_size_short_name_en varchar2(10 char)
)
/

-- changeset JOBTRACKER:1793724733680 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:595dddbb163e6d403cf2f5ee8fe2e6e31997027a:alter

alter table jobtracker.company_sizes add (
    company_size_long_name_en varchar2(100 char)
)
/

-- changeset JOBTRACKER:1793724733692 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:930563293babea442a69bce60f995fcdae1a831b:alter

alter table jobtracker.company_sizes add (
    company_size_short_name_fr varchar2(10 char)
)
/

-- changeset JOBTRACKER:1793724733704 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:0f65c24bf1ccd0b60e54ffc639006a4305d75501:alter

alter table jobtracker.company_sizes add (
    company_size_long_name_fr varchar2(100 char)
)
/

-- changeset JOBTRACKER:1793724733713 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:5a7e7d4b5d54201589da825909f477c5337424e6:alter

alter table jobtracker.company_sizes add constraint company_sizes_company_size_short_name_fr_uk unique ( company_size_short_name_fr )
    using index enable
/

-- changeset JOBTRACKER:1793724733716 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:c597e21b80086902571bedbbea85ab991e5d50ee:alter

alter table jobtracker.company_sizes add constraint company_sizes_company_size_long_name_fr_uk unique ( company_size_long_name_fr )
    using index enable
/

-- changeset JOBTRACKER:1793724733719 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:38c845c82d68ecefac68869812d4234163d1fe10:alter

alter table jobtracker.company_sizes add constraint company_sizes_company_size_short_name_en_uk unique ( company_size_short_name_en )
    using index enable
/

-- changeset JOBTRACKER:1793724733724 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:41dba341d7d273bf3ccd634cc7c8b073cc53db30:73c9b820a55d80adcedb8a5f3ee882d1b8b271a0:alter

alter table jobtracker.company_sizes add constraint company_sizes_company_size_long_name_en_uk unique ( company_size_long_name_en )
    using index enable
/


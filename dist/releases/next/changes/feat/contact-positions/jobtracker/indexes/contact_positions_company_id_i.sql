-- liquibase formatted sql
-- changeset JOBTRACKER:1793796994119 stripComments:false  logicalFilePath:feat/contact-positions/jobtracker/indexes/contact_positions_company_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/contact_positions_company_id_i.sql:null:cb73c721f41a90bcb6bc6189572d4e45d5c88956:create

create index jobtracker.contact_positions_company_id_i on
    jobtracker.contact_positions (
        company_id
    );


-- liquibase formatted sql
-- changeset jobtracker:1793798337103 stripComments:false  logicalFilePath:feat/contact-positions-views/jobtracker/comments/ui_jobs_lov.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ui_jobs_lov.sql:null:069106c05528d1104678249e8e5b715867e746b1:create

comment on table jobtracker.ui_jobs_lov is
    'Liste de valeurs des postes (APEX).';


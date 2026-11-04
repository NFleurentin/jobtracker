-- liquibase formatted sql
-- changeset jobtracker:1793798337105 stripComments:false  logicalFilePath:feat/contact-positions-views/jobtracker/comments/ui_contact_positions_list.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ui_contact_positions_list.sql:null:bde21f9dc75d1ed541adf4219a19a23a8e2bf65c:create

comment on table jobtracker.ui_contact_positions_list is
    'Postes d''un contact, sur sa fiche (APEX). Écritures par contact_api.';


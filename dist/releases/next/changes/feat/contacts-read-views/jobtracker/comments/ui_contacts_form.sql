-- liquibase formatted sql
-- changeset jobtracker:1793739868865 stripComments:false  logicalFilePath:feat/contacts-read-views/jobtracker/comments/ui_contacts_form.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ui_contacts_form.sql:null:2063fde1593fef976056cf7ff007e56ee6fc7288:create

comment on table jobtracker.ui_contacts_form is
    'Formulaire d''un contact (APEX). Écritures par contact_api.';


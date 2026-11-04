-- liquibase formatted sql
-- changeset jobtracker:1793798337091 stripComments:false  logicalFilePath:feat/contact-positions-views/jobtracker/comments/ui_company_contacts_list.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ui_company_contacts_list.sql:null:5c0fe359889a07f2ec2c1dc278ab1228b72c8978:create

comment on table jobtracker.ui_company_contacts_list is
    'Contacts d''une entreprise et leurs postes, sur sa fiche (APEX). Écritures par contact_api.';


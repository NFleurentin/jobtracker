-- liquibase formatted sql
-- changeset jobtracker:1793798337120 stripComments:false  logicalFilePath:feat/contact-positions-views/jobtracker/comments/contact_position_details.sql
-- sqlcl_snapshot src/database/jobtracker/comments/contact_position_details.sql:null:46c9e321cf27922f48c200b2d20f611baf6c0f41:create

comment on table jobtracker.contact_position_details is
    'Postes des contacts avec le nom du contact, de l''entreprise et le libellé du poste.';


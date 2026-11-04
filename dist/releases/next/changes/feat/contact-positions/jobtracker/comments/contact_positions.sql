-- liquibase formatted sql
-- changeset jobtracker:1793796994114 stripComments:false  logicalFilePath:feat/contact-positions/jobtracker/comments/contact_positions.sql
-- sqlcl_snapshot src/database/jobtracker/comments/contact_positions.sql:null:ce4f382d0869729d50c2a350d76f919522ed0534:create

comment on table jobtracker.contact_positions is
    'Postes des contacts dans les entreprises : plusieurs par contact, dans une ou plusieurs entreprises. Pas de période : is_current marque les postes actuels, les anciens se classent par created_at. Écritures par contact_api, qui met à jour updated_at.'
    ;


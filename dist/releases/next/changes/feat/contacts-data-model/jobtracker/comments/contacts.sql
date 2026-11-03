-- liquibase formatted sql
-- changeset jobtracker:1793738246270 stripComments:false  logicalFilePath:feat/contacts-data-model/jobtracker/comments/contacts.sql
-- sqlcl_snapshot src/database/jobtracker/comments/contacts.sql:null:ccec06d9e54e1778b40af8afb71440eb03aef5c2:create

comment on table jobtracker.contacts is
    'Personnes rencontrées dans la recherche : recruteurs, managers, collaborateurs. Écritures par le package, qui met à jour updated_at.'
    ;


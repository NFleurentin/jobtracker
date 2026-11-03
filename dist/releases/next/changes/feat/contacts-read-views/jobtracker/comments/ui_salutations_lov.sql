-- liquibase formatted sql
-- changeset jobtracker:1793739868880 stripComments:false  logicalFilePath:feat/contacts-read-views/jobtracker/comments/ui_salutations_lov.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ui_salutations_lov.sql:null:db3d0c5890de4313662af17a25b97d6bc3fdfaff:create

comment on table jobtracker.ui_salutations_lov is
    'Liste de valeurs des civilités (APEX), forme complète.';


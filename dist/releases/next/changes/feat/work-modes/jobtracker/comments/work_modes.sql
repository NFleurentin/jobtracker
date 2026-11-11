-- liquibase formatted sql
-- changeset jobtracker:1794409965007 stripComments:false  logicalFilePath:feat/work-modes/jobtracker/comments/work_modes.sql
-- sqlcl_snapshot src/database/jobtracker/comments/work_modes.sql:null:ec1d77f6654dad658cb748c35ae5988c2860cdcb:create

comment on table jobtracker.work_modes is
    'Modes de travail d''une offre : présentiel, hybride, télétravail complet. Liste fixe chargée par migration, sans écran de maintenance ; le code est la clé stable des packages.'
    ;


-- liquibase formatted sql
-- changeset jobtracker:1794233895801 stripComments:false  logicalFilePath:feat/application-types/jobtracker/comments/application_types.sql
-- sqlcl_snapshot src/database/jobtracker/comments/application_types.sql:null:29a4ee024342ebee09b7e12d09349b60850d30e6:create

comment on table jobtracker.application_types is
    'Types de candidature selon l''initiative : candidature spontanée, réponse à une offre, approche de l''entreprise. Liste fixe chargée par migration, sans écran de maintenance ; le code est la clé stable des packages.'
    ;


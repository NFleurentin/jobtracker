-- liquibase formatted sql
-- changeset jobtracker:1794235739737 stripComments:false  logicalFilePath:feat/application-statuses/jobtracker/comments/application_statuses.sql
-- sqlcl_snapshot src/database/jobtracker/comments/application_statuses.sql:null:a12b05a923703e9fe799668f2764ccfcbc5eaad9:create

comment on table jobtracker.application_statuses is
    'Statuts de candidature. Liste fixe chargée par migration, sans écran de maintenance ; le code est la clé stable des packages. funnel_step ordonne les étapes mesurées du funnel (null hors funnel) ; is_final marque un statut qui clôt la candidature.'
    ;


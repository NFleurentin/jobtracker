-- liquibase formatted sql
-- changeset jobtracker:1793194915936 stripComments:false  logicalFilePath:feat/collect-staging/jobtracker/comments/collect_runs.sql
-- sqlcl_snapshot src/database/jobtracker/comments/collect_runs.sql:null:6b2ceed843af16cf8ed9148b7d249faa8f197c57:create

comment on table jobtracker.collect_runs is
    'Exécutions de la collecte : une ligne par run et par source, y compris les runs en échec avant toute requête.';

comment on column jobtracker.collect_runs.received_offer_count is
    'Nombre d''offres reçues : entrée du garde-fou de volume.';

comment on column jobtracker.collect_runs.status is
    'RUNNING, SUCCEEDED, FAILED (erreur technique), REJECTED (refusé par le garde-fou de volume).';


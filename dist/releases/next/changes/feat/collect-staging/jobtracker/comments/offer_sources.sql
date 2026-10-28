-- liquibase formatted sql
-- changeset jobtracker:1793194915940 stripComments:false  logicalFilePath:feat/collect-staging/jobtracker/comments/offer_sources.sql
-- sqlcl_snapshot src/database/jobtracker/comments/offer_sources.sql:null:81e0f61be4e643acf37cd52b459e29ffd0bac8f5:create

comment on table jobtracker.offer_sources is
    'Sources d''offres : collectées par API ou saisies à la main.';


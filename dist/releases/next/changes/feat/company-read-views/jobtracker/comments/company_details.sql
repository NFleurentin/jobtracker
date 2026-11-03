-- liquibase formatted sql
-- changeset jobtracker:1793700751662 stripComments:false  logicalFilePath:feat/company-read-views/jobtracker/comments/company_details.sql
-- sqlcl_snapshot src/database/jobtracker/comments/company_details.sql:null:45dc94aeb38e04dd2ea8a1855b0ef42656e62333:create

comment on table jobtracker.company_details is
    'Entreprises avec les libellés de leurs référentiels et de l''entreprise parente.';


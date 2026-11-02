-- liquibase formatted sql
-- changeset jobtracker:1793627281868 stripComments:false  logicalFilePath:feat/company-management/jobtracker/comments/sectors.sql
-- sqlcl_snapshot src/database/jobtracker/comments/sectors.sql:null:cff4d0a86dcf5caf7bf0d30b7837f9adfcec6e84:create

comment on table jobtracker.sectors is
    'Secteurs d''activité des entreprises, orientés recherche d''emploi : ce ne sont pas les sections NAF.';


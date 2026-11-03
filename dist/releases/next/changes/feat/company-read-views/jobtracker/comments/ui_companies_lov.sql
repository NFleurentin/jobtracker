-- liquibase formatted sql
-- changeset jobtracker:1793700751666 stripComments:false  logicalFilePath:feat/company-read-views/jobtracker/comments/ui_companies_lov.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ui_companies_lov.sql:null:842068eccb89c0449dee7fc08f23273b2a7e5692:create

comment on table jobtracker.ui_companies_lov is
    'Liste de valeurs des entreprises (APEX), dont l''entreprise parente.';


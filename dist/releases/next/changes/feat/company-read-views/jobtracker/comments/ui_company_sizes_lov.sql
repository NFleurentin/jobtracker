-- liquibase formatted sql
-- changeset jobtracker:1793700751673 stripComments:false  logicalFilePath:feat/company-read-views/jobtracker/comments/ui_company_sizes_lov.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ui_company_sizes_lov.sql:null:eedbb450124e2d766ace3647edbe47d10b8123f2:create

comment on table jobtracker.ui_company_sizes_lov is
    'Liste de valeurs des tailles d''entreprise (APEX), à trier par display_order.';


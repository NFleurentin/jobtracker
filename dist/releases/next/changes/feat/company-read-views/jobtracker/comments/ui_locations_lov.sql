-- liquibase formatted sql
-- changeset jobtracker:1793700751678 stripComments:false  logicalFilePath:feat/company-read-views/jobtracker/comments/ui_locations_lov.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ui_locations_lov.sql:null:b8a55a07e890eda60172df4ca82693983a00e4aa:create

comment on table jobtracker.ui_locations_lov is
    'Liste de valeurs des lieux (APEX).';


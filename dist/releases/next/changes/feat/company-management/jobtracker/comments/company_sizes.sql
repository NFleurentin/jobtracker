-- liquibase formatted sql
-- changeset jobtracker:1793626961765 stripComments:false  logicalFilePath:feat/company-management/jobtracker/comments/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/comments/company_sizes.sql:null:cf08f9ca4057bdab509dbc6b38cdae07d1eaadb8:create

comment on table jobtracker.company_sizes is
    'Tailles d''entreprise, de la plus petite à la plus grande selon display_order : le tri alphabétique placerait ETI avant PME.';


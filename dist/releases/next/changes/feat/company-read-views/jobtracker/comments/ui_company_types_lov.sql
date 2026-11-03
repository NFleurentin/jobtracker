-- liquibase formatted sql
-- changeset jobtracker:1793700751675 stripComments:false  logicalFilePath:feat/company-read-views/jobtracker/comments/ui_company_types_lov.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ui_company_types_lov.sql:null:cbf6c6c235bc181756438d66bbcd676bc34f13cc:create

comment on table jobtracker.ui_company_types_lov is
    'Liste de valeurs des types d''entreprise (APEX).';


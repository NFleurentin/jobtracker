-- liquibase formatted sql
-- changeset jobtracker:1793700751669 stripComments:false  logicalFilePath:feat/company-read-views/jobtracker/comments/ui_companies_form.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ui_companies_form.sql:null:c1488adcb574d9e0926f00c8d1d9899236cf435f:create

comment on table jobtracker.ui_companies_form is
    'Formulaire d''une entreprise (APEX). Écritures par company_api.';


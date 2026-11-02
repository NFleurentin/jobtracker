-- liquibase formatted sql
-- changeset jobtracker:1793628811854 stripComments:false  logicalFilePath:feat/company-management/jobtracker/comments/companies.sql
-- sqlcl_snapshot src/database/jobtracker/comments/companies.sql:null:75f0d5e31efa6b6d1733b3db4e2e2808ca8a534b:create

comment on table jobtracker.companies is
    'Entreprises suivies : employeurs, ESN, cabinets, clients. Écritures par le package, qui met à jour updated_at et refuse les cycles sur parent_company_id.'
    ;


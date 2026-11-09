-- liquibase formatted sql
-- changeset jobtracker:1794243864742 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/comments/companies.sql
-- sqlcl_snapshot src/database/jobtracker/comments/companies.sql:75f0d5e31efa6b6d1733b3db4e2e2808ca8a534b:406ad219fee30c2a4f770a5f5175247807f541e3:alter

comment on table jobtracker.companies is
    'Entreprises suivies : employeurs, ESN, cabinets, clients. Écritures par le package, qui met à jour updated_at et refuse les cycles sur parent_company_id. is_generic marque l''entreprise générique « Confidentielle », destinataire d''une candidature sans entreprise connue : créée par migration, modifiable mais pas supprimable.'
    ;


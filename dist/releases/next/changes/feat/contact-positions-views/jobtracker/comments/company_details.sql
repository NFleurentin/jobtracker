-- liquibase formatted sql
-- changeset jobtracker:1793798337147 stripComments:false  logicalFilePath:feat/contact-positions-views/jobtracker/comments/company_details.sql
-- sqlcl_snapshot src/database/jobtracker/comments/company_details.sql:45dc94aeb38e04dd2ea8a1855b0ef42656e62333:ea8537e1791ae5d293a8018fdc0d1290a07e6291:alter

comment on table jobtracker.company_details is
    'Entreprises avec les libellés de leurs référentiels, de l''entreprise parente et le nombre de postes de contacts.';


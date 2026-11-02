-- liquibase formatted sql
-- changeset jobtracker:1793626299342 stripComments:false  logicalFilePath:feat/company-management/jobtracker/comments/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/comments/company_types.sql:null:c7b7f088ee50e693675706799431a8b9bba0812d:create

comment on table jobtracker.company_types is
    'Types d''entreprise, selon la relation avec le candidat. ESN : mission chez un client, cabinets de conseil compris. Cabinet de recrutement : intermédiaire, agences d''emploi comprises. Employeur direct : tout autre employeur privé ou entreprise publique. Fonction publique : État, territoriale, hospitalière.'
    ;


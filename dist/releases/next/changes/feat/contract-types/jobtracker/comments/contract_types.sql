-- liquibase formatted sql
-- changeset jobtracker:1794411865993 stripComments:false  logicalFilePath:feat/contract-types/jobtracker/comments/contract_types.sql
-- sqlcl_snapshot src/database/jobtracker/comments/contract_types.sql:null:90df177f1f9c3c64032ada775b51e964b3c049b3:create

comment on table jobtracker.contract_types is
    'Types de contrat d''une offre : CDI, CDD, freelance, intérim, alternance, stage. Liste fixe chargée par migration, sans écran de maintenance ; le code est la clé stable des packages.'
    ;


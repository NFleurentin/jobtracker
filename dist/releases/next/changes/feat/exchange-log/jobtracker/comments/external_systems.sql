-- liquibase formatted sql
-- changeset jobtracker:1794482562688 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/comments/external_systems.sql
-- sqlcl_snapshot src/database/jobtracker/comments/external_systems.sql:null:32631011485e19a630d344823a12ec788d089115:create

comment on table jobtracker.external_systems is
    'Systèmes externes appelés (API...), cités par le journal des échanges. Liste fixe chargée par migration ; le code est la clé stable des packages (constantes de exchange_log).'
    ;


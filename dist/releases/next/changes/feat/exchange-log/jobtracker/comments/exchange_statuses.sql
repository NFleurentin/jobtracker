-- liquibase formatted sql
-- changeset jobtracker:1794482562692 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/comments/exchange_statuses.sql
-- sqlcl_snapshot src/database/jobtracker/comments/exchange_statuses.sql:null:abe7381f990b75af07c6c2cd4976a348961e4743:create

comment on table jobtracker.exchange_statuses is
    'États d''un échange : PENDING (envoyé, sans réponse), COMPLETED (réponse reçue, quel que soit son code), FAILED (aucune réponse : délai, réseau, erreur avant l''envoi). Liste fixe chargée par migration.'
    ;


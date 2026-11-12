-- liquibase formatted sql
-- changeset jobtracker:1794482562685 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/comments/exchange_protocols.sql
-- sqlcl_snapshot src/database/jobtracker/comments/exchange_protocols.sql:null:d07eb2967282f8999af2be9763902cb933cca7ea:create

comment on table jobtracker.exchange_protocols is
    'Protocoles des échanges : chacun fixe la forme des enveloppes JSON request et response du journal. Liste fixe chargée par migration ; le code est la clé stable des packages.'
    ;


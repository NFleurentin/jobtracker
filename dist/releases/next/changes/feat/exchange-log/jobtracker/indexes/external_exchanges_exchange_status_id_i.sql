-- liquibase formatted sql
-- changeset JOBTRACKER:1794482562776 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/indexes/external_exchanges_exchange_status_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/external_exchanges_exchange_status_id_i.sql:null:64b7861e45203e186f6733b2d8a46ac453f723ac:create

create index jobtracker.external_exchanges_exchange_status_id_i on
    jobtracker.external_exchanges (
        exchange_status_id
    );


-- liquibase formatted sql
-- changeset JOBTRACKER:1794482562772 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/indexes/external_exchanges_exchange_protocol_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/external_exchanges_exchange_protocol_id_i.sql:null:249ed5642482478f7d3ccbd6cc266b8044135821:create

create index jobtracker.external_exchanges_exchange_protocol_id_i on
    jobtracker.external_exchanges (
        exchange_protocol_id
    );


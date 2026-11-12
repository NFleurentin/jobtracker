-- liquibase formatted sql
-- changeset JOBTRACKER:1794482562763 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/indexes/external_exchanges_correlation_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/external_exchanges_correlation_id_i.sql:null:17e03877ca52c5ca2a8775ee376b76020d047105:create

create index jobtracker.external_exchanges_correlation_id_i on
    jobtracker.external_exchanges (
        correlation_id
    );


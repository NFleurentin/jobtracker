-- liquibase formatted sql
-- changeset JOBTRACKER:1794482562779 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/indexes/external_exchanges_external_system_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/external_exchanges_external_system_id_i.sql:null:a373aba7d3bbb73bb16f09c196b694fd6c6f809b:create

create index jobtracker.external_exchanges_external_system_id_i on
    jobtracker.external_exchanges (
        external_system_id
    );


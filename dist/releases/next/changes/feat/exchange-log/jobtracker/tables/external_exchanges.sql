-- liquibase formatted sql
-- changeset JOBTRACKER:1794482562806 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/tables/external_exchanges.sql
-- sqlcl_snapshot src/database/jobtracker/tables/external_exchanges.sql:null:b3b59679ab07b37ba8608281b098d0db20949625:create

create table jobtracker.external_exchanges (
    external_exchange_id number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20
    noorder nocycle nokeep noscale not null enable,
    external_system_id   number not null enable,
    exchange_protocol_id number not null enable,
    exchange_status_id   number not null enable,
    correlation_id       raw(16),
    request              json not null enable,
    response             json,
    error_message        varchar2(4000 char),
    started_at           timestamp(6) with time zone not null enable,
    ended_at             timestamp(6) with time zone,
    app_user             varchar2(255 char) not null enable,
    apex_session_id      number,
    db_module            varchar2(64 char),
    db_action            varchar2(64 char),
    db_sid               number
);

-- changeset JOBTRACKER:1794482562821 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/tables/external_exchanges.sql
-- sqlcl_snapshot src/database/jobtracker/tables/external_exchanges.sql:null:4d0b109639136c5714993be4f4c42140431c4283:create

alter table jobtracker.external_exchanges
    add constraint external_exchanges_dates_ck check ( ended_at >= started_at ) enable;

-- changeset JOBTRACKER:1794482562835 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/tables/external_exchanges.sql
-- sqlcl_snapshot src/database/jobtracker/tables/external_exchanges.sql:null:26b8a8c251d74a5ad7c893f1f16f6360744628e0:create

alter table jobtracker.external_exchanges
    add constraint external_exchanges_pk primary key ( external_exchange_id )
        using index enable;


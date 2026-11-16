-- liquibase formatted sql
-- changeset JOBTRACKER:1794849971149 stripComments:false  logicalFilePath:feat/exchange-log-switch/jobtracker/tables/external_systems.sql
-- sqlcl_snapshot src/database/jobtracker/tables/external_systems.sql:c2a68c47be260da9b1b2c12e5e856e32881f34a9:cf6fcb7cb384d21fdb5d12fb15e872bed19dd404:alter

alter table jobtracker.external_systems add (
    is_exchange_logged boolean default true not null enable
)
/


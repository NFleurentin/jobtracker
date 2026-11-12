-- liquibase formatted sql
-- changeset JOBTRACKER:1794496661032 stripComments:false  logicalFilePath:feat/purge-external-exchanges/jobtracker/tables/external_systems.sql
-- sqlcl_snapshot src/database/jobtracker/tables/external_systems.sql:ecb37b5f4cc84c394a933432990bd892cd764d46:27f5f28ad35f1259e6fbf48e70d74f57b1e0578e:alter

alter table jobtracker.external_systems add (
    retention_days number(1, 0) default 7 not null enable
)
/

-- changeset JOBTRACKER:1794496661037 stripComments:false  logicalFilePath:feat/purge-external-exchanges/jobtracker/tables/external_systems.sql
-- sqlcl_snapshot src/database/jobtracker/tables/external_systems.sql:ecb37b5f4cc84c394a933432990bd892cd764d46:4700403131c83f89be454fec43a9eccf75d1b059:alter

alter table jobtracker.external_systems add (
    orphan_delay_minutes number(4, 0) default 60 not null enable
)
/

-- changeset JOBTRACKER:1794496661041 stripComments:false  logicalFilePath:feat/purge-external-exchanges/jobtracker/tables/external_systems.sql
-- sqlcl_snapshot src/database/jobtracker/tables/external_systems.sql:ecb37b5f4cc84c394a933432990bd892cd764d46:ae75a969ddba4f223aca27893bc820ca527d3fb6:alter

alter table jobtracker.external_systems
    add constraint external_systems_retention_days_ck check ( retention_days between 1 and 7 ) enable
/

-- changeset JOBTRACKER:1794496661046 stripComments:false  logicalFilePath:feat/purge-external-exchanges/jobtracker/tables/external_systems.sql
-- sqlcl_snapshot src/database/jobtracker/tables/external_systems.sql:ecb37b5f4cc84c394a933432990bd892cd764d46:8d85d4d0f12dcc5d5bdd80c9965a700d6489a496:alter

alter table jobtracker.external_systems
    add constraint external_systems_orphan_delay_minutes_ck check ( orphan_delay_minutes between 5 and 1440 ) enable
/


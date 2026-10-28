-- liquibase formatted sql
-- changeset JOBTRACKER:1793194915984 stripComments:false  logicalFilePath:feat/collect-staging/jobtracker/tables/collect_runs.sql
-- sqlcl_snapshot src/database/jobtracker/tables/collect_runs.sql:null:14e26d09c45ff6ca4f8f169bf5ce7b5d12082849:create

create table jobtracker.collect_runs (
    run_id               number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20
    noorder nocycle nokeep noscale not null enable,
    source_id            number not null enable,
    status               varchar2(10 char) default 'RUNNING' not null enable,
    started_at           timestamp(6) with time zone default systimestamp not null enable,
    ended_at             timestamp(6) with time zone,
    search_params        json,
    received_offer_count number(10, 0),
    error_message        varchar2(4000 char)
);

-- changeset JOBTRACKER:1793194916007 stripComments:false  logicalFilePath:feat/collect-staging/jobtracker/tables/collect_runs.sql
-- sqlcl_snapshot src/database/jobtracker/tables/collect_runs.sql:null:c7f5944cbb8152757b885ff487d05300ac783e32:create

alter table jobtracker.collect_runs
    add constraint collect_runs_dates_ck check ( ended_at >= started_at ) enable;

-- changeset JOBTRACKER:1793194916025 stripComments:false  logicalFilePath:feat/collect-staging/jobtracker/tables/collect_runs.sql
-- sqlcl_snapshot src/database/jobtracker/tables/collect_runs.sql:null:a780717c04dc21a7e38e9157e8d818c610c93587:create

alter table jobtracker.collect_runs
    add constraint collect_runs_end_ck
        check ( ( status = 'RUNNING'
                  and ended_at is null )
                or ( status <> 'RUNNING'
                     and ended_at is not null ) ) enable;

-- changeset JOBTRACKER:1793194916035 stripComments:false  logicalFilePath:feat/collect-staging/jobtracker/tables/collect_runs.sql
-- sqlcl_snapshot src/database/jobtracker/tables/collect_runs.sql:null:2fe1a18f6999d96b1ea0506e18efb849844ac337:create

alter table jobtracker.collect_runs
    add constraint collect_runs_pk primary key ( run_id )
        using index enable;

-- changeset JOBTRACKER:1793194916045 stripComments:false  logicalFilePath:feat/collect-staging/jobtracker/tables/collect_runs.sql
-- sqlcl_snapshot src/database/jobtracker/tables/collect_runs.sql:null:977392a30e22eb7b75ed29e61d118f1d7d8ec708:create

alter table jobtracker.collect_runs
    add constraint collect_runs_status_ck
        check ( status in ( 'RUNNING', 'SUCCEEDED', 'FAILED', 'REJECTED' ) ) enable;


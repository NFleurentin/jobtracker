-- liquibase formatted sql
-- changeset JOBTRACKER:1793194915997 stripComments:false  logicalFilePath:feat/collect-staging/jobtracker/tables/collect_requests.sql
-- sqlcl_snapshot src/database/jobtracker/tables/collect_requests.sql:null:641b42cfb5dc14562eca3b6caaebc3025b6523c2:create

create table jobtracker.collect_requests (
    request_id            number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20
    noorder nocycle nokeep noscale not null enable,
    run_id                number not null enable,
    request_seq           number(5, 0) not null enable,
    http_method           varchar2(10 char) not null enable,
    request_url           varchar2(4000 char) not null enable,
    request_params        json,
    started_at            timestamp(6) with time zone not null enable,
    ended_at              timestamp(6) with time zone,
    response_code         number(3, 0),
    response_headers      json,
    response_payload_json json,
    error_message         varchar2(4000 char)
);

-- changeset JOBTRACKER:1793194916013 stripComments:false  logicalFilePath:feat/collect-staging/jobtracker/tables/collect_requests.sql
-- sqlcl_snapshot src/database/jobtracker/tables/collect_requests.sql:null:dd12dabbbe19bf2a4236cb51b1ebb5857457a48f:create

alter table jobtracker.collect_requests
    add constraint collect_requests_dates_ck check ( ended_at >= started_at ) enable;

-- changeset JOBTRACKER:1793194916030 stripComments:false  logicalFilePath:feat/collect-staging/jobtracker/tables/collect_requests.sql
-- sqlcl_snapshot src/database/jobtracker/tables/collect_requests.sql:null:80e27069d2430935531be58c02dbbc04cf517d2d:create

alter table jobtracker.collect_requests
    add constraint collect_requests_pk primary key ( request_id )
        using index enable;

-- changeset JOBTRACKER:1793194916040 stripComments:false  logicalFilePath:feat/collect-staging/jobtracker/tables/collect_requests.sql
-- sqlcl_snapshot src/database/jobtracker/tables/collect_requests.sql:null:8a876fa084436f8bab03a9800bb4a7d86453366d:create

alter table jobtracker.collect_requests
    add constraint collect_requests_run_id_request_seq_uk unique ( run_id,
                                                                   request_seq )
        using index enable;


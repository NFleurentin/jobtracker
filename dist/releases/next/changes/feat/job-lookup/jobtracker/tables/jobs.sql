-- liquibase formatted sql
-- changeset JOBTRACKER:1793795578280 stripComments:false  logicalFilePath:feat/job-lookup/jobtracker/tables/jobs.sql
-- sqlcl_snapshot src/database/jobtracker/tables/jobs.sql:null:c2dd37d059b963505be377a6b06a741e7ea35cea:create

create table jobtracker.jobs (
    job_id      number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20 noorder nocycle
    nokeep noscale not null enable,
    job_name_en varchar2(100 char) not null enable,
    job_name_fr varchar2(100 char) not null enable
);

-- changeset JOBTRACKER:1793795578284 stripComments:false  logicalFilePath:feat/job-lookup/jobtracker/tables/jobs.sql
-- sqlcl_snapshot src/database/jobtracker/tables/jobs.sql:null:e8e4f71609c8e7261149eee4ebcbebb608aeb2de:create

alter table jobtracker.jobs
    add constraint jobs_pk primary key ( job_id )
        using index enable;


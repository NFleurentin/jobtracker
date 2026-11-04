-- liquibase formatted sql
-- changeset JOBTRACKER:1793795578275 stripComments:false  logicalFilePath:feat/job-lookup/jobtracker/indexes/jobs_job_name_fr_uk.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/jobs_job_name_fr_uk.sql:null:3d23470d8e3cb948d7afef464f3a672190f3208a:create

create unique index jobtracker.jobs_job_name_fr_uk on
    jobtracker.jobs ( upper(job_name_fr) );


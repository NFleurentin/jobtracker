-- liquibase formatted sql
-- changeset JOBTRACKER:1793795578271 stripComments:false  logicalFilePath:feat/job-lookup/jobtracker/indexes/jobs_job_name_en_uk.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/jobs_job_name_en_uk.sql:null:6d99d5c0e6e195e7c4937f550a3f288d319feba2:create

create unique index jobtracker.jobs_job_name_en_uk on
    jobtracker.jobs ( upper(job_name_en) );


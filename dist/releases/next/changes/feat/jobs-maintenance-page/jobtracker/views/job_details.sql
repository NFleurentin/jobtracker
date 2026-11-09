-- liquibase formatted sql
-- changeset JOBTRACKER:1794220169373 stripComments:false  logicalFilePath:feat/jobs-maintenance-page/jobtracker/views/job_details.sql
-- sqlcl_snapshot src/database/jobtracker/views/job_details.sql:null:5201fb667d0434d2408b175dab4bd60310224bfa:create

create or replace force editionable view jobtracker.job_details (
    job_id,
    job_name_fr,
    job_name_en,
    position_count
) as
    select
        j.job_id,
        j.job_name_fr,
        j.job_name_en,
        (
            select
                count(*)
            from
                jobtracker.contact_positions cp
            where
                cp.job_id = j.job_id
        ) as position_count
    from
        jobtracker.jobs j
with read only;


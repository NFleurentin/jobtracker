-- liquibase formatted sql
-- changeset JOBTRACKER:1794220169381 stripComments:false  logicalFilePath:feat/jobs-maintenance-page/jobtracker/views/ui_jobs_list.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_jobs_list.sql:null:3dcaa684e30b86155141e38fa06aebb8e7b0c1bd:create

create or replace force editionable view jobtracker.ui_jobs_list (
    job_id,
    job_name_fr,
    job_name_en,
    position_count
) as
    select
        job_id,
        job_name_fr,
        job_name_en,
        position_count
    from
        jobtracker.job_details
with read only;


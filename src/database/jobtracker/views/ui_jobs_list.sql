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


-- sqlcl_snapshot {"hash":"3dcaa684e30b86155141e38fa06aebb8e7b0c1bd","type":"VIEW","name":"UI_JOBS_LIST","schemaName":"JOBTRACKER","sxml":""}
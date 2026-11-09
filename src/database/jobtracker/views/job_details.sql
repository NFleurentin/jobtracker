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


-- sqlcl_snapshot {"hash":"5201fb667d0434d2408b175dab4bd60310224bfa","type":"VIEW","name":"JOB_DETAILS","schemaName":"JOBTRACKER","sxml":""}
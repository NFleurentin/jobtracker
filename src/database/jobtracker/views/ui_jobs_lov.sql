create or replace force editionable view jobtracker.ui_jobs_lov (
    return_value,
    display_value
) as
    select
        job_id as return_value,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                job_name_en
            else
                job_name_fr
        end    as display_value
    from
        jobtracker.jobs
with read only;


-- sqlcl_snapshot {"hash":"6b0086718abcddfa757222d33ed1b8634390231b","type":"VIEW","name":"UI_JOBS_LOV","schemaName":"JOBTRACKER","sxml":""}
-- liquibase formatted sql
-- changeset JOBTRACKER:1793798337125 stripComments:false  logicalFilePath:feat/contact-positions-views/jobtracker/views/ui_jobs_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_jobs_lov.sql:null:6b0086718abcddfa757222d33ed1b8634390231b:create

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


-- liquibase formatted sql
-- changeset JOBTRACKER:1794302514275 stripComments:false  logicalFilePath:feat/applications-read-views/jobtracker/views/ui_applications_form.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_applications_form.sql:null:2ecc780326591b22abc7d04abcae0096abc3ef69:create

create or replace force editionable view jobtracker.ui_applications_form (
    application_id,
    company_id,
    application_type_id,
    job_title,
    annual_salary_proposed_euros,
    daily_rate_proposed_euros,
    interest_rating,
    note_text,
    application_status_id,
    status_changed_at,
    created_at,
    updated_at
) as
    select
        application_id,
        company_id,
        application_type_id,
        job_title,
        annual_salary_proposed_euros,
        daily_rate_proposed_euros,
        interest_rating,
        note_text,
        application_status_id,
        cast(status_changed_at as timestamp with local time zone) as status_changed_at,
        cast(created_at as timestamp with local time zone)        as created_at,
        cast(updated_at as timestamp with local time zone)        as updated_at
    from
        jobtracker.application_details
with read only;


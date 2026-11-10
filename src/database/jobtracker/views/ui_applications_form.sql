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


-- sqlcl_snapshot {"hash":"2ecc780326591b22abc7d04abcae0096abc3ef69","type":"VIEW","name":"UI_APPLICATIONS_FORM","schemaName":"JOBTRACKER","sxml":""}
-- liquibase formatted sql
-- changeset JOBTRACKER:1794302514263 stripComments:false  logicalFilePath:feat/applications-read-views/jobtracker/views/ui_applications_list.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_applications_list.sql:null:a8c7b52b86e919126e3e91a998acd284c1902637:create

create or replace force editionable view jobtracker.ui_applications_list (
    application_id,
    company_id,
    company_name,
    is_generic_company,
    application_type_name,
    job_title,
    interest_rating,
    application_status_name,
    application_status_display_order,
    is_final,
    status_changed_at,
    updated_at
) as
    select
        application_id,
        company_id,
        company_name,
        is_generic_company,
        application_type_name,
        job_title,
        interest_rating,
        application_status_name,
        application_status_display_order,
        is_final,
        cast(status_changed_at as timestamp with local time zone) as status_changed_at,
        cast(updated_at as timestamp with local time zone)        as updated_at
    from
        jobtracker.application_details
with read only;


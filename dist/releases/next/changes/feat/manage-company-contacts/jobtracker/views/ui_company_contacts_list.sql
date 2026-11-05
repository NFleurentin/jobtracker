-- liquibase formatted sql
-- changeset JOBTRACKER:1793883994537 stripComments:false  logicalFilePath:feat/manage-company-contacts/jobtracker/views/ui_company_contacts_list.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_company_contacts_list.sql:7fb77aea00525ca5ab55ce809656105a2950b678:f44bcc56d9a0139043af4088320f296e61bb2d2a:alter

create or replace force editionable view jobtracker.ui_company_contacts_list (
    contact_position_id,
    company_id,
    contact_id,
    last_name,
    first_name,
    job_id,
    job_name,
    is_current,
    created_at
) as
    select
        contact_position_id,
        company_id,
        contact_id,
        last_name,
        first_name,
        job_id,
        job_name,
        is_current,
        cast(created_at as timestamp with local time zone) as created_at
    from
        jobtracker.contact_position_details
with read only;


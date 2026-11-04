-- liquibase formatted sql
-- changeset JOBTRACKER:1793798337100 stripComments:false  logicalFilePath:feat/contact-positions-views/jobtracker/views/ui_company_contacts_list.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_company_contacts_list.sql:null:7fb77aea00525ca5ab55ce809656105a2950b678:create

create or replace force editionable view jobtracker.ui_company_contacts_list (
    contact_position_id,
    company_id,
    contact_id,
    last_name,
    first_name,
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
        job_name,
        is_current,
        cast(created_at as timestamp with local time zone) as created_at
    from
        jobtracker.contact_position_details
with read only;


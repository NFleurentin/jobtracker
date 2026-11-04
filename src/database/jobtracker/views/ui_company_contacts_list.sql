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


-- sqlcl_snapshot {"hash":"7fb77aea00525ca5ab55ce809656105a2950b678","type":"VIEW","name":"UI_COMPANY_CONTACTS_LIST","schemaName":"JOBTRACKER","sxml":""}
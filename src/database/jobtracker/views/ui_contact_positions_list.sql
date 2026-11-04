create or replace force editionable view jobtracker.ui_contact_positions_list (
    contact_position_id,
    contact_id,
    company_id,
    company_name,
    job_name,
    is_current,
    created_at
) as
    select
        contact_position_id,
        contact_id,
        company_id,
        company_name,
        job_name,
        is_current,
        cast(created_at as timestamp with local time zone) as created_at
    from
        jobtracker.contact_position_details
with read only;


-- sqlcl_snapshot {"hash":"9bc876dca9d14f94e711a9ed4f360c1e230ae3f6","type":"VIEW","name":"UI_CONTACT_POSITIONS_LIST","schemaName":"JOBTRACKER","sxml":""}
create or replace force editionable view jobtracker.ui_contacts_form (
    contact_id,
    first_name,
    last_name,
    salutation_id,
    email,
    phone,
    linkedin_slug,
    note_text,
    position_count,
    created_at,
    updated_at
) as
    select
        contact_id,
        first_name,
        last_name,
        salutation_id,
        email,
        phone,
        linkedin_slug,
        note_text,
        position_count,
        cast(created_at as timestamp with local time zone) as created_at,
        cast(updated_at as timestamp with local time zone) as updated_at
    from
        jobtracker.contact_details
with read only;


-- sqlcl_snapshot {"hash":"fbce74764b9222e353d6c82863a6ed3ce94549ab","type":"VIEW","name":"UI_CONTACTS_FORM","schemaName":"JOBTRACKER","sxml":""}
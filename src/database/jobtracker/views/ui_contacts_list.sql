create or replace force editionable view jobtracker.ui_contacts_list (
    contact_id,
    salutation_short_name,
    last_name,
    first_name,
    updated_at
) as
    select
        contact_id,
        salutation_short_name,
        last_name,
        first_name,
        cast(updated_at as timestamp with local time zone) as updated_at
    from
        jobtracker.contact_details
with read only;


-- sqlcl_snapshot {"hash":"927dcb5bde8726029793d864e75ba49323e3e1c4","type":"VIEW","name":"UI_CONTACTS_LIST","schemaName":"JOBTRACKER","sxml":""}
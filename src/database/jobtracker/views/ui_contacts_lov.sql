create or replace force editionable view jobtracker.ui_contacts_lov (
    return_value,
    display_value
) as
    select
        contact_id            as return_value,
        trim(last_name
             || ' ' || first_name) as display_value
    from
        jobtracker.contacts
with read only;


-- sqlcl_snapshot {"hash":"5345c8392b1e5b8fb3327781f8554b7f5c45ba1a","type":"VIEW","name":"UI_CONTACTS_LOV","schemaName":"JOBTRACKER","sxml":""}
-- liquibase formatted sql
-- changeset JOBTRACKER:1793739868999 stripComments:false  logicalFilePath:feat/contacts-read-views/jobtracker/views/ui_contacts_form.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_contacts_form.sql:null:ca19928dc0b7d602d52ca794ae91a195c97cac4d:create

create or replace force editionable view jobtracker.ui_contacts_form (
    contact_id,
    first_name,
    last_name,
    salutation_id,
    email,
    phone,
    linkedin_slug,
    note_text,
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
        cast(created_at as timestamp with local time zone) as created_at,
        cast(updated_at as timestamp with local time zone) as updated_at
    from
        jobtracker.contacts
with read only;


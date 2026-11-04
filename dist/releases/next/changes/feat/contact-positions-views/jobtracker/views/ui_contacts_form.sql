-- liquibase formatted sql
-- changeset JOBTRACKER:1793798337178 stripComments:false  logicalFilePath:feat/contact-positions-views/jobtracker/views/ui_contacts_form.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_contacts_form.sql:ca19928dc0b7d602d52ca794ae91a195c97cac4d:fbce74764b9222e353d6c82863a6ed3ce94549ab:alter

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


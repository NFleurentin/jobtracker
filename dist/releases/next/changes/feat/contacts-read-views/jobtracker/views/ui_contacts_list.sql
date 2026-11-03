-- liquibase formatted sql
-- changeset JOBTRACKER:1793739869030 stripComments:false  logicalFilePath:feat/contacts-read-views/jobtracker/views/ui_contacts_list.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_contacts_list.sql:null:927dcb5bde8726029793d864e75ba49323e3e1c4:create

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


-- liquibase formatted sql
-- changeset JOBTRACKER:1793883994524 stripComments:false  logicalFilePath:feat/manage-company-contacts/jobtracker/views/ui_contacts_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_contacts_lov.sql:null:5345c8392b1e5b8fb3327781f8554b7f5c45ba1a:create

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


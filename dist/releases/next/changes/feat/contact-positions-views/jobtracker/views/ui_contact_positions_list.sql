-- liquibase formatted sql
-- changeset JOBTRACKER:1793798337131 stripComments:false  logicalFilePath:feat/contact-positions-views/jobtracker/views/ui_contact_positions_list.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_contact_positions_list.sql:null:9bc876dca9d14f94e711a9ed4f360c1e230ae3f6:create

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


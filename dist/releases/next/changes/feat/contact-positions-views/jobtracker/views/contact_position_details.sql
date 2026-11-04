-- liquibase formatted sql
-- changeset JOBTRACKER:1793798337117 stripComments:false  logicalFilePath:feat/contact-positions-views/jobtracker/views/contact_position_details.sql
-- sqlcl_snapshot src/database/jobtracker/views/contact_position_details.sql:null:d51ce967ca5f449dcc6b3ca5eee9407923673a1b:create

create or replace force editionable view jobtracker.contact_position_details (
    contact_position_id,
    contact_id,
    first_name,
    last_name,
    company_id,
    company_name,
    job_id,
    job_name,
    is_current,
    created_at,
    updated_at
) as
    select
        cp.contact_position_id,
        cp.contact_id,
        ct.first_name,
        ct.last_name,
        cp.company_id,
        co.company_name,
        cp.job_id,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                j.job_name_en
            else
                j.job_name_fr
        end as job_name,
        cp.is_current,
        cp.created_at,
        cp.updated_at
    from
             jobtracker.contact_positions cp
        join jobtracker.contacts  ct on ct.contact_id = cp.contact_id
        join jobtracker.companies co on co.company_id = cp.company_id
        join jobtracker.jobs      j on j.job_id = cp.job_id
with read only;


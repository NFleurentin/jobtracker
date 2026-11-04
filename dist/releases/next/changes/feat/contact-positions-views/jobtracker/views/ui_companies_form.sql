-- liquibase formatted sql
-- changeset JOBTRACKER:1793798337192 stripComments:false  logicalFilePath:feat/contact-positions-views/jobtracker/views/ui_companies_form.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_companies_form.sql:04336ef4b0bdbaf16312544438cda48a6d8f25b2:cadb8aa99f794b3fa70a2d71f32468537feb966b:alter

create or replace force editionable view jobtracker.ui_companies_form (
    company_id,
    company_name,
    description,
    note_text,
    parent_company_id,
    company_type_id,
    sector_id,
    company_size_id,
    location_id,
    siren,
    website_url,
    linkedin_slug,
    email,
    phone,
    creation_year,
    position_count,
    created_at,
    updated_at
) as
    select
        company_id,
        company_name,
        description,
        note_text,
        parent_company_id,
        company_type_id,
        sector_id,
        company_size_id,
        location_id,
        siren,
        website_url,
        linkedin_slug,
        email,
        phone,
        creation_year,
        position_count,
        cast(created_at as timestamp with local time zone) as created_at,
        cast(updated_at as timestamp with local time zone) as updated_at
    from
        jobtracker.company_details
with read only;


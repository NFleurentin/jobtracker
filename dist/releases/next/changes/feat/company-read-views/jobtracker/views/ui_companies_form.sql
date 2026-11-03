-- liquibase formatted sql
-- changeset JOBTRACKER:1793700751708 stripComments:false  logicalFilePath:feat/company-read-views/jobtracker/views/ui_companies_form.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_companies_form.sql:null:6b23285427b7caab5583c910d3416985c66c46a8:create

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
        created_at,
        updated_at
    from
        jobtracker.companies
with read only;


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


-- sqlcl_snapshot {"hash":"6b23285427b7caab5583c910d3416985c66c46a8","type":"VIEW","name":"UI_COMPANIES_FORM","schemaName":"JOBTRACKER","sxml":""}
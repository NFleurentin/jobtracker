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


-- sqlcl_snapshot {"hash":"cadb8aa99f794b3fa70a2d71f32468537feb966b","type":"VIEW","name":"UI_COMPANIES_FORM","schemaName":"JOBTRACKER","sxml":""}
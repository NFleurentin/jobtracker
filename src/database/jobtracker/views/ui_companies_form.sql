create or replace force editionable view jobtracker.ui_companies_form (
    company_id,
    company_name,
    is_generic,
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
    delete_mode,
    created_at,
    updated_at
) as
    select
        company_id,
        company_name,
        is_generic,
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
        case
            when is_generic then
                'NONE'
            when position_count = 0 then
                'SIMPLE'
            else
                'WITH_POSITIONS'
        end                                                as delete_mode,
        cast(created_at as timestamp with local time zone) as created_at,
        cast(updated_at as timestamp with local time zone) as updated_at
    from
        jobtracker.company_details
with read only;


-- sqlcl_snapshot {"hash":"98c48c406131cff08fdd04ad4b91fb0929085cf9","type":"VIEW","name":"UI_COMPANIES_FORM","schemaName":"JOBTRACKER","sxml":""}
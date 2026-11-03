create or replace force editionable view jobtracker.ui_companies_list (
    company_id,
    company_name,
    parent_company_name,
    company_type_name,
    sector_name,
    company_size_short_name,
    company_size_display_order,
    location_name,
    creation_year,
    updated_at
) as
    select
        company_id,
        company_name,
        parent_company_name,
        company_type_name,
        sector_name,
        company_size_short_name,
        company_size_display_order,
        location_name,
        creation_year,
        updated_at
    from
        jobtracker.company_details
with read only;


-- sqlcl_snapshot {"hash":"fcc249c3024d886f252687e2a884cef07e46beec","type":"VIEW","name":"UI_COMPANIES_LIST","schemaName":"JOBTRACKER","sxml":""}
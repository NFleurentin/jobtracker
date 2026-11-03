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
        cast(updated_at as timestamp with local time zone) as updated_at
    from
        jobtracker.company_details
with read only;


-- sqlcl_snapshot {"hash":"3e51d2c99a1f35c3a8e22c48cf145f028186005d","type":"VIEW","name":"UI_COMPANIES_LIST","schemaName":"JOBTRACKER","sxml":""}
create or replace force editionable view jobtracker.company_details (
    company_id,
    company_name,
    description,
    note_text,
    parent_company_id,
    parent_company_name,
    company_type_id,
    company_type_name,
    sector_id,
    sector_name,
    company_size_id,
    company_size_short_name,
    company_size_long_name,
    company_size_display_order,
    location_id,
    location_name,
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
        c.company_id,
        c.company_name,
        c.description,
        c.note_text,
        c.parent_company_id,
        p.company_name   as parent_company_name,
        c.company_type_id,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                ct.company_type_name_en
            else
                ct.company_type_name
        end              as company_type_name,
        c.sector_id,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                s.sector_name_en
            else
                s.sector_name
        end              as sector_name,
        c.company_size_id,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                cs.company_size_short_name_en
            else
                cs.company_size_short_name
        end              as company_size_short_name,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                cs.company_size_long_name_en
            else
                cs.company_size_long_name
        end              as company_size_long_name,
        cs.display_order as company_size_display_order,
        c.location_id,
        l.location_name,
        c.siren,
        c.website_url,
        c.linkedin_slug,
        c.email,
        c.phone,
        c.creation_year,
        c.created_at,
        c.updated_at
    from
        jobtracker.companies     c
        left join jobtracker.companies     p on p.company_id = c.parent_company_id
        left join jobtracker.company_types ct on ct.company_type_id = c.company_type_id
        left join jobtracker.sectors       s on s.sector_id = c.sector_id
        left join jobtracker.company_sizes cs on cs.company_size_id = c.company_size_id
        left join jobtracker.locations     l on l.location_id = c.location_id
with read only;


-- sqlcl_snapshot {"hash":"161ddf2562ec67e37697032dcf422d78d245a779","type":"VIEW","name":"COMPANY_DETAILS","schemaName":"JOBTRACKER","sxml":""}
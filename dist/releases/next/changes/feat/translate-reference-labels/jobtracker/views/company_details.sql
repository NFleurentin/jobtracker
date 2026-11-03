-- liquibase formatted sql
-- changeset JOBTRACKER:1793724733528 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/views/company_details.sql
-- sqlcl_snapshot src/database/jobtracker/views/company_details.sql:cb7f7bf30a09f7864374be083100edc2fd4c6a95:4f2a42d693b38b9cf3fc2e2d4e3f04e434e3bffd:alter

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
                ct.company_type_name_fr
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
                s.sector_name_fr
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
                cs.company_size_short_name_fr
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
                cs.company_size_long_name_fr
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


-- liquibase formatted sql
-- changeset JOBTRACKER:1793709036002 stripComments:false  logicalFilePath:feat/apex-companies-pages/jobtracker/views/ui_companies_list.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_companies_list.sql:fcc249c3024d886f252687e2a884cef07e46beec:3e51d2c99a1f35c3a8e22c48cf145f028186005d:alter

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


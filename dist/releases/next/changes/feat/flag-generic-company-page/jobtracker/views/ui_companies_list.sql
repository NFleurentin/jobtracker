-- liquibase formatted sql
-- changeset JOBTRACKER:1794256187609 stripComments:false  logicalFilePath:feat/flag-generic-company-page/jobtracker/views/ui_companies_list.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_companies_list.sql:3e51d2c99a1f35c3a8e22c48cf145f028186005d:c117bd5f4bc22b7df36dd9922c0d29a2619e6357:alter

create or replace force editionable view jobtracker.ui_companies_list (
    company_id,
    company_name,
    is_generic,
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
        is_generic,
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


-- liquibase formatted sql
-- changeset JOBTRACKER:1793700751726 stripComments:false  logicalFilePath:feat/company-read-views/jobtracker/views/ui_company_types_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_company_types_lov.sql:null:b9a3d932bdb4b86b764c18888cfad054dacbb367:create

create or replace force editionable view jobtracker.ui_company_types_lov (
    return_value,
    display_value
) as
    select
        company_type_id   as return_value,
        company_type_name as display_value
    from
        jobtracker.company_types
with read only;


-- liquibase formatted sql
-- changeset JOBTRACKER:1793700751717 stripComments:false  logicalFilePath:feat/company-read-views/jobtracker/views/ui_companies_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_companies_lov.sql:null:00cd87b7067be84826863c93696f119d24857f79:create

create or replace force editionable view jobtracker.ui_companies_lov (
    return_value,
    display_value
) as
    select
        company_id   as return_value,
        company_name as display_value
    from
        jobtracker.companies
with read only;


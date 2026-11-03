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


-- sqlcl_snapshot {"hash":"00cd87b7067be84826863c93696f119d24857f79","type":"VIEW","name":"UI_COMPANIES_LOV","schemaName":"JOBTRACKER","sxml":""}
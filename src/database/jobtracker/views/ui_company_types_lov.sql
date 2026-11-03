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


-- sqlcl_snapshot {"hash":"b9a3d932bdb4b86b764c18888cfad054dacbb367","type":"VIEW","name":"UI_COMPANY_TYPES_LOV","schemaName":"JOBTRACKER","sxml":""}
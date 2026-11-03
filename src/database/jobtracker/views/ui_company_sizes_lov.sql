create or replace force editionable view jobtracker.ui_company_sizes_lov (
    return_value,
    display_value,
    display_order
) as
    select
        company_size_id        as return_value,
        company_size_long_name as display_value,
        display_order
    from
        jobtracker.company_sizes
with read only;


-- sqlcl_snapshot {"hash":"45c1de3477b66fda704f5c40d0389d2335cfadd4","type":"VIEW","name":"UI_COMPANY_SIZES_LOV","schemaName":"JOBTRACKER","sxml":""}
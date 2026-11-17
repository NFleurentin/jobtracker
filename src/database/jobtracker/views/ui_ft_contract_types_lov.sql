create or replace force editionable view jobtracker.ui_ft_contract_types_lov (
    return_value,
    display_value
) as
    select
        contract_type_code as return_value,
        contract_type_name as display_value
    from
        jobtracker.ft_contract_type_details
    where
        is_current
with read only;


-- sqlcl_snapshot {"hash":"badcf474a6a5e455d5ad3e01aec3152f6e9ce9ce","type":"VIEW","name":"UI_FT_CONTRACT_TYPES_LOV","schemaName":"JOBTRACKER","sxml":""}
create or replace force editionable view jobtracker.ft_contract_type_details (
    contract_type_id,
    contract_type_code,
    contract_type_name,
    ft_referential_load_id,
    is_current
) as
    select
        t.contract_type_id,
        t.contract_type_code,
        t.contract_type_name,
        t.ft_referential_load_id,
        case
            when t.ft_referential_load_id = l.last_load_id then
                true
            else
                false
        end as is_current
    from
             jobtracker.ft_contract_types t
        cross join (
            select
                max(ft_referential_load_id) as last_load_id
            from
                jobtracker.ft_contract_types
        ) l
with read only;


-- sqlcl_snapshot {"hash":"49d0926260909f58928d3dbc376592e3e2d22294","type":"VIEW","name":"FT_CONTRACT_TYPE_DETAILS","schemaName":"JOBTRACKER","sxml":""}
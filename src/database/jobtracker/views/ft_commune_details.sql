create or replace force editionable view jobtracker.ft_commune_details (
    commune_id,
    commune_code,
    commune_name,
    postal_code,
    department_code,
    ft_referential_load_id,
    is_current
) as
    select
        t.commune_id,
        t.commune_code,
        t.commune_name,
        t.postal_code,
        t.department_code,
        t.ft_referential_load_id,
        case
            when t.ft_referential_load_id = l.last_load_id then
                true
            else
                false
        end as is_current
    from
             jobtracker.ft_communes t
        cross join (
            select
                max(ft_referential_load_id) as last_load_id
            from
                jobtracker.ft_communes
        ) l
with read only;


-- sqlcl_snapshot {"hash":"cb4d3e0144ee45b22e07eb3aed8f60d5d75de067","type":"VIEW","name":"FT_COMMUNE_DETAILS","schemaName":"JOBTRACKER","sxml":""}
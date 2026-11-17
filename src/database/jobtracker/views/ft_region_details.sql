create or replace force editionable view jobtracker.ft_region_details (
    region_id,
    region_code,
    region_name,
    ft_referential_load_id,
    is_current
) as
    select
        t.region_id,
        t.region_code,
        t.region_name,
        t.ft_referential_load_id,
        case
            when t.ft_referential_load_id = l.last_load_id then
                true
            else
                false
        end as is_current
    from
             jobtracker.ft_regions t
        cross join (
            select
                max(ft_referential_load_id) as last_load_id
            from
                jobtracker.ft_regions
        ) l
with read only;


-- sqlcl_snapshot {"hash":"1de9821150b4d5f5bbcfb32e30a799aa79c76511","type":"VIEW","name":"FT_REGION_DETAILS","schemaName":"JOBTRACKER","sxml":""}
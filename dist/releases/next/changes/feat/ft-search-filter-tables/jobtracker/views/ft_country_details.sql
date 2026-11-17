-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337930 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/views/ft_country_details.sql
-- sqlcl_snapshot src/database/jobtracker/views/ft_country_details.sql:null:558dc1d159e02fb30cf8e88de64e4324f8f4617e:create

create or replace force editionable view jobtracker.ft_country_details (
    country_id,
    country_code,
    country_name,
    ft_referential_load_id,
    is_current
) as
    select
        t.country_id,
        t.country_code,
        t.country_name,
        t.ft_referential_load_id,
        case
            when t.ft_referential_load_id = l.last_load_id then
                true
            else
                false
        end as is_current
    from
             jobtracker.ft_countries t
        cross join (
            select
                max(ft_referential_load_id) as last_load_id
            from
                jobtracker.ft_countries
        ) l
with read only;


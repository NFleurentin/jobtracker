-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337918 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/views/ft_continent_details.sql
-- sqlcl_snapshot src/database/jobtracker/views/ft_continent_details.sql:null:a991e171e4b95a78eaa25008542f197b7a1a107e:create

create or replace force editionable view jobtracker.ft_continent_details (
    continent_id,
    continent_code,
    continent_name,
    ft_referential_load_id,
    is_current
) as
    select
        t.continent_id,
        t.continent_code,
        t.continent_name,
        t.ft_referential_load_id,
        case
            when t.ft_referential_load_id = l.last_load_id then
                true
            else
                false
        end as is_current
    from
             jobtracker.ft_continents t
        cross join (
            select
                max(ft_referential_load_id) as last_load_id
            from
                jobtracker.ft_continents
        ) l
with read only;


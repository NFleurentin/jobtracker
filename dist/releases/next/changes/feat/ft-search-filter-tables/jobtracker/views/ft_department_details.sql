-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337937 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/views/ft_department_details.sql
-- sqlcl_snapshot src/database/jobtracker/views/ft_department_details.sql:null:2b28df5b63dc2ace2224fa88cbbe04b07729323c:create

create or replace force editionable view jobtracker.ft_department_details (
    department_id,
    department_code,
    department_name,
    region_code,
    ft_referential_load_id,
    is_current
) as
    select
        t.department_id,
        t.department_code,
        t.department_name,
        t.region_code,
        t.ft_referential_load_id,
        case
            when t.ft_referential_load_id = l.last_load_id then
                true
            else
                false
        end as is_current
    from
             jobtracker.ft_departments t
        cross join (
            select
                max(ft_referential_load_id) as last_load_id
            from
                jobtracker.ft_departments
        ) l
with read only;


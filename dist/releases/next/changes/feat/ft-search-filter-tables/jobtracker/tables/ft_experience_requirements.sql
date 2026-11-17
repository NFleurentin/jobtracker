-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337885 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_experience_requirements.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_experience_requirements.sql:null:975ae5c5d11d4c38ed0fa87a60766e921c3f2612:create

create table jobtracker.ft_experience_requirements (
    experience_requirement_id   number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache
    20 noorder nocycle nokeep noscale not null enable,
    experience_requirement_code varchar2(10 char) not null enable,
    experience_requirement_name varchar2(100 char) not null enable
);

-- changeset JOBTRACKER:1794922337962 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_experience_requirements.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_experience_requirements.sql:null:8866aefaba4d16fc7776e46f7766077b36dafb81:create

alter table jobtracker.ft_experience_requirements add constraint ft_experience_requirements_experience_requirement_code_uk unique ( experience_requirement_code
)
    using index enable;

-- changeset JOBTRACKER:1794922337995 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_experience_requirements.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_experience_requirements.sql:null:c7c61d4ec0184ebfa3dfc5515993cb029b706187:create

alter table jobtracker.ft_experience_requirements
    add constraint ft_experience_requirements_pk primary key ( experience_requirement_id )
        using index enable;


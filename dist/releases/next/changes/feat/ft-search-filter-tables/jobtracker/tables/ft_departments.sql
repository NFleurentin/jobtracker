-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337880 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_departments.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_departments.sql:null:0ddd1c13163fad915fd549726773e0547f5c3431:create

create table jobtracker.ft_departments (
    department_id          number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20
    noorder nocycle nokeep noscale not null enable,
    department_code        varchar2(10 char) not null enable,
    department_name        varchar2(100 char) not null enable,
    region_code            varchar2(10 char),
    ft_referential_load_id number not null enable
);

-- changeset JOBTRACKER:1794922337959 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_departments.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_departments.sql:null:29bd3c565eea5fb1f946cff8214fcee37b15efc3:create

alter table jobtracker.ft_departments add constraint ft_departments_department_code_uk unique ( department_code )
    using index enable;

-- changeset JOBTRACKER:1794922337992 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_departments.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_departments.sql:null:de4ad279ffcf321a0d88b31429754430055acee4:create

alter table jobtracker.ft_departments
    add constraint ft_departments_pk primary key ( department_id )
        using index enable;


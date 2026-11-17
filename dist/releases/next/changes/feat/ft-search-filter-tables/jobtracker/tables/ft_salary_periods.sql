-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337904 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_salary_periods.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_salary_periods.sql:null:40470acf27dd08db27b855bdc35900f11352d1a1:create

create table jobtracker.ft_salary_periods (
    salary_period_id   number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20 noorder
    nocycle nokeep noscale not null enable,
    salary_period_code varchar2(10 char) not null enable,
    salary_period_name varchar2(100 char) not null enable
);

-- changeset JOBTRACKER:1794922337976 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_salary_periods.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_salary_periods.sql:null:010d3b208c135b47c0bb7c926a692bcd1d8a3e8d:create

alter table jobtracker.ft_salary_periods
    add constraint ft_salary_periods_pk primary key ( salary_period_id )
        using index enable;

-- changeset JOBTRACKER:1794922338010 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_salary_periods.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_salary_periods.sql:null:813c3f468684db8bfbad1ba1485211edf979b4c6:create

alter table jobtracker.ft_salary_periods add constraint ft_salary_periods_salary_period_code_uk unique ( salary_period_code )
    using index enable;


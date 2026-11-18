-- liquibase formatted sql
-- changeset JOBTRACKER:1794994602484 stripComments:false  logicalFilePath:feat/offer-search-filters/jobtracker/tables/ft_posting_periods.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_posting_periods.sql:null:fb48619aab06be8f98eee1ada8822b5d7414b8f0:create

create table jobtracker.ft_posting_periods (
    posting_period_id   number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20 noorder
    nocycle nokeep noscale not null enable,
    posting_period_code varchar2(10 char) not null enable,
    posting_period_name varchar2(100 char) not null enable
);

-- changeset JOBTRACKER:1794994602488 stripComments:false  logicalFilePath:feat/offer-search-filters/jobtracker/tables/ft_posting_periods.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_posting_periods.sql:null:dee3529bd5f836002f7f07c6910e930d91e98a12:create

alter table jobtracker.ft_posting_periods
    add constraint ft_posting_periods_pk primary key ( posting_period_id )
        using index enable;

-- changeset JOBTRACKER:1794994602492 stripComments:false  logicalFilePath:feat/offer-search-filters/jobtracker/tables/ft_posting_periods.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_posting_periods.sql:null:215dcc4127b43f778195a6151015cc6600f891df:create

alter table jobtracker.ft_posting_periods add constraint ft_posting_periods_posting_period_code_uk unique ( posting_period_code )
    using index enable;


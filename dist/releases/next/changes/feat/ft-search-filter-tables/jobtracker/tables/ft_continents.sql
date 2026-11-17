-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337866 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_continents.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_continents.sql:null:5eb6c1e2e187063320d606d49e2766db24e14360:create

create table jobtracker.ft_continents (
    continent_id           number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20
    noorder nocycle nokeep noscale not null enable,
    continent_code         varchar2(10 char) not null enable,
    continent_name         varchar2(100 char) not null enable,
    ft_referential_load_id number not null enable
);

-- changeset JOBTRACKER:1794922337951 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_continents.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_continents.sql:null:b8c4f04e1104e56fe8f4fd9950f1ff4e40b605c7:create

alter table jobtracker.ft_continents add constraint ft_continents_continent_code_uk unique ( continent_code )
    using index enable;

-- changeset JOBTRACKER:1794922337983 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_continents.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_continents.sql:null:d47f6b1f3aa8cf5934d77d1eabf0ab1021ba18e7:create

alter table jobtracker.ft_continents
    add constraint ft_continents_pk primary key ( continent_id )
        using index enable;


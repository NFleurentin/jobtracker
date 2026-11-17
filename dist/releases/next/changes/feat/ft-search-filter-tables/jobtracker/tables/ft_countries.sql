-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337876 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_countries.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_countries.sql:null:811be35dabbc6f92005ccc134569a5ce243e1ad4:create

create table jobtracker.ft_countries (
    country_id             number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20
    noorder nocycle nokeep noscale not null enable,
    country_code           varchar2(10 char) not null enable,
    country_name           varchar2(100 char) not null enable,
    ft_referential_load_id number not null enable
);

-- changeset JOBTRACKER:1794922337956 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_countries.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_countries.sql:null:d4fbbd68dc0b3f548d54b6c74e7d5e564099afdf:create

alter table jobtracker.ft_countries add constraint ft_countries_country_code_uk unique ( country_code )
    using index enable;

-- changeset JOBTRACKER:1794922337989 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_countries.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_countries.sql:null:6238a7d171d349f17a8c01dd56f06c417215553c:create

alter table jobtracker.ft_countries
    add constraint ft_countries_pk primary key ( country_id )
        using index enable;


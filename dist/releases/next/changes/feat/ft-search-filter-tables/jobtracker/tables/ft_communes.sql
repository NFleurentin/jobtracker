-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337861 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_communes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_communes.sql:null:979617cdf2c7aea3bfbf47519789a53505adf4b3:create

create table jobtracker.ft_communes (
    commune_id             number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20
    noorder nocycle nokeep noscale not null enable,
    commune_code           varchar2(10 char) not null enable,
    commune_name           varchar2(100 char) not null enable,
    postal_code            varchar2(10 char),
    department_code        varchar2(10 char),
    ft_referential_load_id number not null enable
);

-- changeset JOBTRACKER:1794922337948 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_communes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_communes.sql:null:7fcec7a307e2c9a05c24c09c2f159eedcc397b6f:create

alter table jobtracker.ft_communes add constraint ft_communes_commune_code_uk unique ( commune_code )
    using index enable;

-- changeset JOBTRACKER:1794922337979 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_communes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_communes.sql:null:e8d737396fa5fee5c8e1924b81126ada6e472e81:create

alter table jobtracker.ft_communes
    add constraint ft_communes_pk primary key ( commune_id )
        using index enable;


-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337888 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_experiences.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_experiences.sql:null:682803ec4961a77d15b8761bc68557e81ef9c0ef:create

create table jobtracker.ft_experiences (
    experience_id   number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20 noorder
    nocycle nokeep noscale not null enable,
    experience_code varchar2(10 char) not null enable,
    experience_name varchar2(100 char) not null enable
);

-- changeset JOBTRACKER:1794922337964 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_experiences.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_experiences.sql:null:4cd9c8f9df0fb434164618dde97a4769c5acc8f7:create

alter table jobtracker.ft_experiences add constraint ft_experiences_experience_code_uk unique ( experience_code )
    using index enable;

-- changeset JOBTRACKER:1794922337997 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_experiences.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_experiences.sql:null:16130cb1760d4972ecca0e333a827e80c84149f1:create

alter table jobtracker.ft_experiences
    add constraint ft_experiences_pk primary key ( experience_id )
        using index enable;


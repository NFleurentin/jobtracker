-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337892 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_offer_origins.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_offer_origins.sql:null:7ebe94711f94a3c8d6f6d98c6ad2cdab1f06dea5:create

create table jobtracker.ft_offer_origins (
    offer_origin_id   number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20 noorder
    nocycle nokeep noscale not null enable,
    offer_origin_code varchar2(10 char) not null enable,
    offer_origin_name varchar2(100 char) not null enable
);

-- changeset JOBTRACKER:1794922337967 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_offer_origins.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_offer_origins.sql:null:44bf400be0af5dcb7d36420275f1e3486da0e905:create

alter table jobtracker.ft_offer_origins add constraint ft_offer_origins_offer_origin_code_uk unique ( offer_origin_code )
    using index enable;

-- changeset JOBTRACKER:1794922338001 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_offer_origins.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_offer_origins.sql:null:37d341def8a547253f574d25c7c363669023f12d:create

alter table jobtracker.ft_offer_origins
    add constraint ft_offer_origins_pk primary key ( offer_origin_id )
        using index enable;


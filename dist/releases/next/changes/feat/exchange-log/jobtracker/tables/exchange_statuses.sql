-- liquibase formatted sql
-- changeset JOBTRACKER:1794482562795 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/tables/exchange_statuses.sql
-- sqlcl_snapshot src/database/jobtracker/tables/exchange_statuses.sql:null:c9f730635ed8d3dec9c9edb80cf664b5fe2469c0:create

create table jobtracker.exchange_statuses (
    exchange_status_id      number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache
    20 noorder nocycle nokeep noscale not null enable,
    exchange_status_code    varchar2(20 char) not null enable,
    exchange_status_name_fr varchar2(50 char) not null enable,
    exchange_status_name_en varchar2(50 char) not null enable
);

-- changeset JOBTRACKER:1794482562813 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/tables/exchange_statuses.sql
-- sqlcl_snapshot src/database/jobtracker/tables/exchange_statuses.sql:null:31d59dd71c7d9f30f6bdd92a7aadf70aa232e137:create

alter table jobtracker.exchange_statuses add constraint exchange_statuses_exchange_status_code_uk unique ( exchange_status_code )
    using index enable;

-- changeset JOBTRACKER:1794482562827 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/tables/exchange_statuses.sql
-- sqlcl_snapshot src/database/jobtracker/tables/exchange_statuses.sql:null:2a02c384451e96a6e8a19310bf7bc54cdf9aa9c3:create

alter table jobtracker.exchange_statuses add constraint exchange_statuses_exchange_status_name_en_uk unique ( exchange_status_name_en
)
    using index enable;

-- changeset JOBTRACKER:1794482562841 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/tables/exchange_statuses.sql
-- sqlcl_snapshot src/database/jobtracker/tables/exchange_statuses.sql:null:9cd8c98e744919d5e5a152d27144a50e6a47218e:create

alter table jobtracker.exchange_statuses add constraint exchange_statuses_exchange_status_name_fr_uk unique ( exchange_status_name_fr
)
    using index enable;

-- changeset JOBTRACKER:1794482562851 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/tables/exchange_statuses.sql
-- sqlcl_snapshot src/database/jobtracker/tables/exchange_statuses.sql:null:89f411520a43c5299ef7d5416a14f6027e6eb9bd:create

alter table jobtracker.exchange_statuses
    add constraint exchange_statuses_pk primary key ( exchange_status_id )
        using index enable;


-- liquibase formatted sql
-- changeset JOBTRACKER:1794482562784 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/tables/exchange_protocols.sql
-- sqlcl_snapshot src/database/jobtracker/tables/exchange_protocols.sql:null:ed00fb0c4faf8ec3dc7c338672925a52a6a14a5e:create

create table jobtracker.exchange_protocols (
    exchange_protocol_id      number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache
    20 noorder nocycle nokeep noscale not null enable,
    exchange_protocol_code    varchar2(20 char) not null enable,
    exchange_protocol_name_fr varchar2(50 char) not null enable,
    exchange_protocol_name_en varchar2(50 char) not null enable
);

-- changeset JOBTRACKER:1794482562809 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/tables/exchange_protocols.sql
-- sqlcl_snapshot src/database/jobtracker/tables/exchange_protocols.sql:null:38df5ac3321a5b89001b1453bb2d3276bdb823b0:create

alter table jobtracker.exchange_protocols add constraint exchange_protocols_exchange_protocol_code_uk unique ( exchange_protocol_code
)
    using index enable;

-- changeset JOBTRACKER:1794482562824 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/tables/exchange_protocols.sql
-- sqlcl_snapshot src/database/jobtracker/tables/exchange_protocols.sql:null:b6cc2b2d4cefeec55583efd5a48a8756ac11bf0d:create

alter table jobtracker.exchange_protocols add constraint exchange_protocols_exchange_protocol_name_en_uk unique ( exchange_protocol_name_en
)
    using index enable;

-- changeset JOBTRACKER:1794482562837 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/tables/exchange_protocols.sql
-- sqlcl_snapshot src/database/jobtracker/tables/exchange_protocols.sql:null:0643be9c6e28938fa5dc7c128423a2a7d58dd7bb:create

alter table jobtracker.exchange_protocols add constraint exchange_protocols_exchange_protocol_name_fr_uk unique ( exchange_protocol_name_fr
)
    using index enable;

-- changeset JOBTRACKER:1794482562848 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/tables/exchange_protocols.sql
-- sqlcl_snapshot src/database/jobtracker/tables/exchange_protocols.sql:null:43f9693e6505a47171381f779a30c2515021f878:create

alter table jobtracker.exchange_protocols
    add constraint exchange_protocols_pk primary key ( exchange_protocol_id )
        using index enable;


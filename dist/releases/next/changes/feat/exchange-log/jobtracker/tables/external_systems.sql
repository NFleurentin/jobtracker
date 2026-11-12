-- liquibase formatted sql
-- changeset JOBTRACKER:1794482562799 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/tables/external_systems.sql
-- sqlcl_snapshot src/database/jobtracker/tables/external_systems.sql:null:f8f1b95ae3b5d48059486f7d617f17548fc2d1af:create

create table jobtracker.external_systems (
    external_system_id      number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache
    20 noorder nocycle nokeep noscale not null enable,
    external_system_code    varchar2(30 char) not null enable,
    external_system_name_fr varchar2(50 char) not null enable,
    external_system_name_en varchar2(50 char) not null enable
);

-- changeset JOBTRACKER:1794482562817 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/tables/external_systems.sql
-- sqlcl_snapshot src/database/jobtracker/tables/external_systems.sql:null:19913135422c34e6b31c298d821a76855b977a61:create

alter table jobtracker.external_systems add constraint external_systems_external_system_code_uk unique ( external_system_code )
    using index enable;

-- changeset JOBTRACKER:1794482562831 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/tables/external_systems.sql
-- sqlcl_snapshot src/database/jobtracker/tables/external_systems.sql:null:40f91d90f94f5af891747a07e40237a9504f311c:create

alter table jobtracker.external_systems add constraint external_systems_external_system_name_en_uk unique ( external_system_name_en )
    using index enable;

-- changeset JOBTRACKER:1794482562845 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/tables/external_systems.sql
-- sqlcl_snapshot src/database/jobtracker/tables/external_systems.sql:null:e296cdfd42dc72af14a75695f108fd989e0fe914:create

alter table jobtracker.external_systems add constraint external_systems_external_system_name_fr_uk unique ( external_system_name_fr )
    using index enable;

-- changeset JOBTRACKER:1794482562854 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/tables/external_systems.sql
-- sqlcl_snapshot src/database/jobtracker/tables/external_systems.sql:null:b8987cffe47ee4220f0d2119a17ad52d54f61ad1:create

alter table jobtracker.external_systems
    add constraint external_systems_pk primary key ( external_system_id )
        using index enable;


-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337871 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_contract_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_contract_types.sql:null:0b774e9c1afe5d381572cc8fb1ff580521cc18c3:create

create table jobtracker.ft_contract_types (
    contract_type_id       number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20
    noorder nocycle nokeep noscale not null enable,
    contract_type_code     varchar2(10 char) not null enable,
    contract_type_name     varchar2(100 char) not null enable,
    ft_referential_load_id number not null enable
);

-- changeset JOBTRACKER:1794922337954 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_contract_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_contract_types.sql:null:c632a58a6423e31f55ff2632a1754f164e81401a:create

alter table jobtracker.ft_contract_types add constraint ft_contract_types_contract_type_code_uk unique ( contract_type_code )
    using index enable;

-- changeset JOBTRACKER:1794922337986 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_contract_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_contract_types.sql:null:3d5d27802c5728b5608144331dcfa872dbe37cb7:create

alter table jobtracker.ft_contract_types
    add constraint ft_contract_types_pk primary key ( contract_type_id )
        using index enable;


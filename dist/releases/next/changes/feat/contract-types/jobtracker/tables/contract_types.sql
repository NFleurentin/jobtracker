-- liquibase formatted sql
-- changeset JOBTRACKER:1794411866002 stripComments:false  logicalFilePath:feat/contract-types/jobtracker/tables/contract_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/contract_types.sql:null:7a57c18c837f94b5078451df48cd0f8990effe81:create

create table jobtracker.contract_types (
    contract_type_id      number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20
    noorder nocycle nokeep noscale not null enable,
    contract_type_code    varchar2(20 char) not null enable,
    contract_type_name_fr varchar2(50 char) not null enable,
    contract_type_name_en varchar2(50 char) not null enable
);

-- changeset JOBTRACKER:1794411866007 stripComments:false  logicalFilePath:feat/contract-types/jobtracker/tables/contract_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/contract_types.sql:null:56bba319bb04f977a203f0ca5ef73a9873801839:create

alter table jobtracker.contract_types add constraint contract_types_contract_type_code_uk unique ( contract_type_code )
    using index enable;

-- changeset JOBTRACKER:1794411866012 stripComments:false  logicalFilePath:feat/contract-types/jobtracker/tables/contract_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/contract_types.sql:null:96d3360c89e8b4bda0be6275143aefda89b01a9e:create

alter table jobtracker.contract_types add constraint contract_types_contract_type_name_en_uk unique ( contract_type_name_en )
    using index enable;

-- changeset JOBTRACKER:1794411866017 stripComments:false  logicalFilePath:feat/contract-types/jobtracker/tables/contract_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/contract_types.sql:null:c123ca1e8204f62dfbb26d3bb18ab339de6024f7:create

alter table jobtracker.contract_types add constraint contract_types_contract_type_name_fr_uk unique ( contract_type_name_fr )
    using index enable;

-- changeset JOBTRACKER:1794411866023 stripComments:false  logicalFilePath:feat/contract-types/jobtracker/tables/contract_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/contract_types.sql:null:58af330676f5350616d5f76732b3b56ec27ee52a:create

alter table jobtracker.contract_types
    add constraint contract_types_pk primary key ( contract_type_id )
        using index enable;


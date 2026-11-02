-- liquibase formatted sql
-- changeset JOBTRACKER:1793626299350 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:null:b21ce085b4debe3969d45e13439264078eb9b5e2:create

create table jobtracker.company_types (
    company_type_id   number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20 noorder
    nocycle nokeep noscale not null enable,
    company_type_code varchar2(30 char) not null enable,
    company_type_name varchar2(100 char) not null enable
);

-- changeset JOBTRACKER:1793626299355 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:null:9e28b8b5efc0649a085108f1c5d229223026f53f:create

alter table jobtracker.company_types add constraint company_types_company_type_code_uk unique ( company_type_code )
    using index enable;

-- changeset JOBTRACKER:1793626299360 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:null:842ffc53c61f6e440759d8b2d824f51cd29c929c:create

alter table jobtracker.company_types add constraint company_types_company_type_name_uk unique ( company_type_name )
    using index enable;

-- changeset JOBTRACKER:1793626299366 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/company_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_types.sql:null:f6e0bee745808506cf0692aa5d17cab52001878b:create

alter table jobtracker.company_types
    add constraint company_types_pk primary key ( company_type_id )
        using index enable;


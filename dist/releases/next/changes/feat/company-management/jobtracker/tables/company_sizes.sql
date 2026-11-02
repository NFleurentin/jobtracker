-- liquibase formatted sql
-- changeset JOBTRACKER:1793626961778 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:null:46c8af2217e70e299d24ec25d0c6b997ed258292:create

create table jobtracker.company_sizes (
    company_size_id         number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache
    20 noorder nocycle nokeep noscale not null enable,
    company_size_short_name varchar2(10 char) not null enable,
    company_size_long_name  varchar2(100 char) not null enable,
    display_order           number(3, 0) not null enable
);

-- changeset JOBTRACKER:1793626961787 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:null:b48ba8fa7608218aff9cc43fb286e1c3163ab7dd:create

alter table jobtracker.company_sizes add constraint company_sizes_company_size_long_name_uk unique ( company_size_long_name )
    using index enable;

-- changeset JOBTRACKER:1793626961795 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:null:005267437bd970ce242d499e4f33db8c2b26afc9:create

alter table jobtracker.company_sizes add constraint company_sizes_company_size_short_name_uk unique ( company_size_short_name )
    using index enable;

-- changeset JOBTRACKER:1793626961804 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:null:a0b812ca0af15197551653db5166e3cb001c0197:create

alter table jobtracker.company_sizes add constraint company_sizes_display_order_uk unique ( display_order )
    using index enable;

-- changeset JOBTRACKER:1793626961809 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:null:f77ad420bfdb060feb5ff03f218020c34d2ddd4d:create

alter table jobtracker.company_sizes
    add constraint company_sizes_pk primary key ( company_size_id )
        using index enable;


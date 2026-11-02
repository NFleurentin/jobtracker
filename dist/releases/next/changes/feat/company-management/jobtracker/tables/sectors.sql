-- liquibase formatted sql
-- changeset JOBTRACKER:1793627281878 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/sectors.sql
-- sqlcl_snapshot src/database/jobtracker/tables/sectors.sql:null:bc16e100e9b2b8aae75ee92e9d434317a7defe80:create

create table jobtracker.sectors (
    sector_id   number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20 noorder nocycle
    nokeep noscale not null enable,
    sector_name varchar2(100 char) not null enable
);

-- changeset JOBTRACKER:1793627281898 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/sectors.sql
-- sqlcl_snapshot src/database/jobtracker/tables/sectors.sql:null:c72a90f5ffcacb552646ad1b684155bbd8362e4e:create

alter table jobtracker.sectors
    add constraint sectors_pk primary key ( sector_id )
        using index enable;

-- changeset JOBTRACKER:1793627281911 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/sectors.sql
-- sqlcl_snapshot src/database/jobtracker/tables/sectors.sql:null:0acc9fab0c7028cbc74e7951642f7b57a314d791:create

alter table jobtracker.sectors add constraint sectors_sector_name_uk unique ( sector_name )
    using index enable;


-- liquibase formatted sql
-- changeset JOBTRACKER:1793627616454 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:null:44da00a53c2bff1394632204bd527f7a17c9fb32:create

create table jobtracker.location_types (
    location_type_id   number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20 noorder
    nocycle nokeep noscale not null enable,
    location_type_code varchar2(30 char) not null enable,
    location_type_name varchar2(100 char) not null enable
);

-- changeset JOBTRACKER:1793627616474 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:null:58a8a937d4562d9e0af1e0278fe5ed0519216252:create

alter table jobtracker.location_types add constraint location_types_location_type_code_uk unique ( location_type_code )
    using index enable;

-- changeset JOBTRACKER:1793627616489 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:null:ac6bab417704a811f01c2c80bbc5354e16dbde58:create

alter table jobtracker.location_types add constraint location_types_location_type_name_uk unique ( location_type_name )
    using index enable;

-- changeset JOBTRACKER:1793627616501 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/location_types.sql:null:a35dccfc94c87a38f45befa064b14b464ce6eff4:create

alter table jobtracker.location_types
    add constraint location_types_pk primary key ( location_type_id )
        using index enable;


-- liquibase formatted sql
-- changeset JOBTRACKER:1794233895810 stripComments:false  logicalFilePath:feat/application-types/jobtracker/tables/application_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/application_types.sql:null:219989f08d8e5073b85f5f0dbde142c10d94af86:create

create table jobtracker.application_types (
    application_type_id      number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache
    20 noorder nocycle nokeep noscale not null enable,
    application_type_code    varchar2(20 char) not null enable,
    application_type_name_fr varchar2(50 char) not null enable,
    application_type_name_en varchar2(50 char) not null enable
);

-- changeset JOBTRACKER:1794233895815 stripComments:false  logicalFilePath:feat/application-types/jobtracker/tables/application_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/application_types.sql:null:908c5ab3ba1103c151985d42a406104454f487ff:create

alter table jobtracker.application_types add constraint application_types_application_type_code_uk unique ( application_type_code )
    using index enable;

-- changeset JOBTRACKER:1794233895820 stripComments:false  logicalFilePath:feat/application-types/jobtracker/tables/application_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/application_types.sql:null:d2cbf34fde3e388a6e30750d72aff114a015956d:create

alter table jobtracker.application_types add constraint application_types_application_type_name_en_uk unique ( application_type_name_en
)
    using index enable;

-- changeset JOBTRACKER:1794233895825 stripComments:false  logicalFilePath:feat/application-types/jobtracker/tables/application_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/application_types.sql:null:6f0879903a44627af87d70c9c23d09bf8ad3c7b2:create

alter table jobtracker.application_types add constraint application_types_application_type_name_fr_uk unique ( application_type_name_fr
)
    using index enable;

-- changeset JOBTRACKER:1794233895829 stripComments:false  logicalFilePath:feat/application-types/jobtracker/tables/application_types.sql
-- sqlcl_snapshot src/database/jobtracker/tables/application_types.sql:null:6eae69822bcbcb71fbc940327ed914b50eeeced4:create

alter table jobtracker.application_types
    add constraint application_types_pk primary key ( application_type_id )
        using index enable;


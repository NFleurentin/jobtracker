-- liquibase formatted sql
-- changeset JOBTRACKER:1793738246474 stripComments:false  logicalFilePath:feat/contacts-data-model/jobtracker/tables/salutations.sql
-- sqlcl_snapshot src/database/jobtracker/tables/salutations.sql:null:5a30377dbdf19bd82a2461168cfd826af112e7a3:create

create table jobtracker.salutations (
    salutation_id            number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache
    20 noorder nocycle nokeep noscale not null enable,
    salutation_code          varchar2(10 char) not null enable,
    salutation_short_name_fr varchar2(10 char) not null enable,
    salutation_long_name_fr  varchar2(30 char) not null enable,
    salutation_short_name_en varchar2(10 char) not null enable,
    salutation_long_name_en  varchar2(30 char) not null enable
);

-- changeset JOBTRACKER:1793738246505 stripComments:false  logicalFilePath:feat/contacts-data-model/jobtracker/tables/salutations.sql
-- sqlcl_snapshot src/database/jobtracker/tables/salutations.sql:null:e3baadeee76734d48165732e483f7a4c7ab242cc:create

alter table jobtracker.salutations
    add constraint salutations_pk primary key ( salutation_id )
        using index enable;

-- changeset JOBTRACKER:1793738246530 stripComments:false  logicalFilePath:feat/contacts-data-model/jobtracker/tables/salutations.sql
-- sqlcl_snapshot src/database/jobtracker/tables/salutations.sql:null:883052c0ce7ffbb8fab39427027428893b062195:create

alter table jobtracker.salutations add constraint salutations_salutation_code_uk unique ( salutation_code )
    using index enable;

-- changeset JOBTRACKER:1793738246543 stripComments:false  logicalFilePath:feat/contacts-data-model/jobtracker/tables/salutations.sql
-- sqlcl_snapshot src/database/jobtracker/tables/salutations.sql:null:e9c49f2a483ff1399812c0152b3e9234b4a3de05:create

alter table jobtracker.salutations add constraint salutations_salutation_long_name_en_uk unique ( salutation_long_name_en )
    using index enable;

-- changeset JOBTRACKER:1793738246554 stripComments:false  logicalFilePath:feat/contacts-data-model/jobtracker/tables/salutations.sql
-- sqlcl_snapshot src/database/jobtracker/tables/salutations.sql:null:3077e8555ee15e9486239fcc71dd94a8d6b76c41:create

alter table jobtracker.salutations add constraint salutations_salutation_long_name_fr_uk unique ( salutation_long_name_fr )
    using index enable;

-- changeset JOBTRACKER:1793738246570 stripComments:false  logicalFilePath:feat/contacts-data-model/jobtracker/tables/salutations.sql
-- sqlcl_snapshot src/database/jobtracker/tables/salutations.sql:null:dc1e3e51f5e77d72580c80c33454716db6c41d4f:create

alter table jobtracker.salutations add constraint salutations_salutation_short_name_en_uk unique ( salutation_short_name_en )
    using index enable;

-- changeset JOBTRACKER:1793738246584 stripComments:false  logicalFilePath:feat/contacts-data-model/jobtracker/tables/salutations.sql
-- sqlcl_snapshot src/database/jobtracker/tables/salutations.sql:null:0236ab4724bee14300d753ce653d9e0502f16d1b:create

alter table jobtracker.salutations add constraint salutations_salutation_short_name_fr_uk unique ( salutation_short_name_fr )
    using index enable;


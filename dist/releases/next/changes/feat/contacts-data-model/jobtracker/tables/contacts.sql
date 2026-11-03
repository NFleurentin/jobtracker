-- liquibase formatted sql
-- changeset JOBTRACKER:1793738246454 stripComments:false  logicalFilePath:feat/contacts-data-model/jobtracker/tables/contacts.sql
-- sqlcl_snapshot src/database/jobtracker/tables/contacts.sql:null:41060dc1f51ab5a8a46e097cbfbb00a1c564de2d:create

create table jobtracker.contacts (
    contact_id    number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20 noorder
    nocycle nokeep noscale not null enable,
    first_name    varchar2(100 char),
    last_name     varchar2(100 char) not null enable,
    salutation_id number,
    email         varchar2(254 char),
    phone         varchar2(30 char),
    linkedin_slug varchar2(100 char),
    note_text     clob,
    created_at    timestamp(6) with time zone default systimestamp not null enable,
    updated_at    timestamp(6) with time zone default systimestamp not null enable
);

-- changeset JOBTRACKER:1793738246490 stripComments:false  logicalFilePath:feat/contacts-data-model/jobtracker/tables/contacts.sql
-- sqlcl_snapshot src/database/jobtracker/tables/contacts.sql:null:9f2b5f7717e598a975cccfe4251b6930236d05ed:create

alter table jobtracker.contacts
    add constraint contacts_linkedin_slug_ck check ( regexp_like ( linkedin_slug,
                                                                   '^[^/[:space:]]+$' ) ) enable;

-- changeset JOBTRACKER:1793738246520 stripComments:false  logicalFilePath:feat/contacts-data-model/jobtracker/tables/contacts.sql
-- sqlcl_snapshot src/database/jobtracker/tables/contacts.sql:null:0977e00b713991a14e59843311d58c25e4921e35:create

alter table jobtracker.contacts
    add constraint contacts_pk primary key ( contact_id )
        using index enable;


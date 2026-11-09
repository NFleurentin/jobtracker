-- liquibase formatted sql
-- changeset JOBTRACKER:1794235739749 stripComments:false  logicalFilePath:feat/application-statuses/jobtracker/tables/application_statuses.sql
-- sqlcl_snapshot src/database/jobtracker/tables/application_statuses.sql:null:45f97653fabbcdce2bbbeef0a5d31cc5b7f97f25:create

create table jobtracker.application_statuses (
    application_status_id      number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache
    20 noorder nocycle nokeep noscale not null enable,
    application_status_code    varchar2(20 char) not null enable,
    application_status_name_fr varchar2(50 char) not null enable,
    application_status_name_en varchar2(50 char) not null enable,
    display_order              number(3, 0) not null enable,
    funnel_step                number(2, 0),
    is_final                   boolean not null enable
);

-- changeset JOBTRACKER:1794235739758 stripComments:false  logicalFilePath:feat/application-statuses/jobtracker/tables/application_statuses.sql
-- sqlcl_snapshot src/database/jobtracker/tables/application_statuses.sql:null:0fc90493a1bed6aa8ef571627a0d89fcff6867e4:create

alter table jobtracker.application_statuses add constraint application_statuses_application_status_code_uk unique ( application_status_code
)
    using index enable;

-- changeset JOBTRACKER:1794235739764 stripComments:false  logicalFilePath:feat/application-statuses/jobtracker/tables/application_statuses.sql
-- sqlcl_snapshot src/database/jobtracker/tables/application_statuses.sql:null:64687c524f736619de49d61c5bbe81e6ff3084b8:create

alter table jobtracker.application_statuses add constraint application_statuses_application_status_name_en_uk unique ( application_status_name_en
)
    using index enable;

-- changeset JOBTRACKER:1794235739769 stripComments:false  logicalFilePath:feat/application-statuses/jobtracker/tables/application_statuses.sql
-- sqlcl_snapshot src/database/jobtracker/tables/application_statuses.sql:null:1af71d530fb0c1417c3988fcb6aa098c58bba557:create

alter table jobtracker.application_statuses add constraint application_statuses_application_status_name_fr_uk unique ( application_status_name_fr
)
    using index enable;

-- changeset JOBTRACKER:1794235739774 stripComments:false  logicalFilePath:feat/application-statuses/jobtracker/tables/application_statuses.sql
-- sqlcl_snapshot src/database/jobtracker/tables/application_statuses.sql:null:721fd090a4b27c402508c67b4f8ed7e737bfb04c:create

alter table jobtracker.application_statuses add constraint application_statuses_display_order_uk unique ( display_order )
    using index enable;

-- changeset JOBTRACKER:1794235739778 stripComments:false  logicalFilePath:feat/application-statuses/jobtracker/tables/application_statuses.sql
-- sqlcl_snapshot src/database/jobtracker/tables/application_statuses.sql:null:c5133dbe26a1a8a52dbaed6b2934d0c22119a2b1:create

alter table jobtracker.application_statuses add constraint application_statuses_funnel_step_ck check ( funnel_step > 0 ) enable;

-- changeset JOBTRACKER:1794235739782 stripComments:false  logicalFilePath:feat/application-statuses/jobtracker/tables/application_statuses.sql
-- sqlcl_snapshot src/database/jobtracker/tables/application_statuses.sql:null:8a89f6c37cad20b734251838e2ef70a2eed5d08b:create

alter table jobtracker.application_statuses add constraint application_statuses_funnel_step_uk unique ( funnel_step )
    using index enable;

-- changeset JOBTRACKER:1794235739785 stripComments:false  logicalFilePath:feat/application-statuses/jobtracker/tables/application_statuses.sql
-- sqlcl_snapshot src/database/jobtracker/tables/application_statuses.sql:null:c06b6b71e9b52f53ac44c9aaeb0cf27157a5dc07:create

alter table jobtracker.application_statuses
    add constraint application_statuses_pk primary key ( application_status_id )
        using index enable;


-- liquibase formatted sql
-- changeset JOBTRACKER:1793716941424 stripComments:false  logicalFilePath:feat/db-message-catalog/jobtracker/tables/app_messages.sql
-- sqlcl_snapshot src/database/jobtracker/tables/app_messages.sql:null:a6870903ceeaac6a885f5e3c2748b011d35b0bfb:create

create table jobtracker.app_messages (
    message_id    number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20 noorder
    nocycle nokeep noscale not null enable,
    message_key   varchar2(128 char) not null enable,
    language_code varchar2(2 char) not null enable,
    message_text  varchar2(1000 char) not null enable
);

-- changeset JOBTRACKER:1793716941430 stripComments:false  logicalFilePath:feat/db-message-catalog/jobtracker/tables/app_messages.sql
-- sqlcl_snapshot src/database/jobtracker/tables/app_messages.sql:null:8b1cd3aa79dc0080ed18b3a683c97bd2c4fd8f2c:create

alter table jobtracker.app_messages
    add constraint app_messages_language_code_ck check ( regexp_like ( language_code,
                                                                       '^[a-z]{2}$' ) ) enable;

-- changeset JOBTRACKER:1793716941435 stripComments:false  logicalFilePath:feat/db-message-catalog/jobtracker/tables/app_messages.sql
-- sqlcl_snapshot src/database/jobtracker/tables/app_messages.sql:null:d0f9ba749c7e744f781aa7f93dd33e33070b185c:create

alter table jobtracker.app_messages
    add constraint app_messages_message_key_ck check ( regexp_like ( message_key,
                                                                     '^[A-Z][A-Z0-9_]*$' ) ) enable;

-- changeset JOBTRACKER:1793716941441 stripComments:false  logicalFilePath:feat/db-message-catalog/jobtracker/tables/app_messages.sql
-- sqlcl_snapshot src/database/jobtracker/tables/app_messages.sql:null:a7a273c7e68d2d098d2ddb2d0f13d78636010137:create

alter table jobtracker.app_messages
    add constraint app_messages_message_key_language_code_uk unique ( message_key,
                                                                      language_code )
        using index enable;

-- changeset JOBTRACKER:1793716941447 stripComments:false  logicalFilePath:feat/db-message-catalog/jobtracker/tables/app_messages.sql
-- sqlcl_snapshot src/database/jobtracker/tables/app_messages.sql:null:55842bb01556067f5042be6b167a0bcc52078179:create

alter table jobtracker.app_messages
    add constraint app_messages_pk primary key ( message_id )
        using index enable;


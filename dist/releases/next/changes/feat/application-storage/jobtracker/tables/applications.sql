-- liquibase formatted sql
-- changeset JOBTRACKER:1794246056095 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/tables/applications.sql
-- sqlcl_snapshot src/database/jobtracker/tables/applications.sql:null:03908c852652aaa5113fea7af58fb1d786f920c4:create

create table jobtracker.applications (
    application_id               number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache
    20 noorder nocycle nokeep noscale not null enable,
    company_id                   number not null enable,
    application_type_id          number not null enable,
    job_title                    varchar2(200 char) not null enable,
    annual_salary_proposed_euros number(9, 0),
    daily_rate_proposed_euros    number(5, 0),
    interest_rating              number(1, 0),
    note_text                    clob,
    created_at                   timestamp(6) with time zone default systimestamp not null enable,
    updated_at                   timestamp(6) with time zone default systimestamp not null enable
);

-- changeset JOBTRACKER:1794246056105 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/tables/applications.sql
-- sqlcl_snapshot src/database/jobtracker/tables/applications.sql:null:dec624c081eb60f80efd98911132ca5e19a750e9:create

alter table jobtracker.applications add constraint applications_annual_salary_proposed_euros_ck check ( annual_salary_proposed_euros > 0
) enable;

-- changeset JOBTRACKER:1794246056109 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/tables/applications.sql
-- sqlcl_snapshot src/database/jobtracker/tables/applications.sql:null:fd7c4c5572eb9069c163bcaea4dce0354fe6227b:create

alter table jobtracker.applications add constraint applications_daily_rate_proposed_euros_ck check ( daily_rate_proposed_euros > 0 ) enable
;

-- changeset JOBTRACKER:1794246056112 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/tables/applications.sql
-- sqlcl_snapshot src/database/jobtracker/tables/applications.sql:null:21f8300fcecf5b8892735c44b29be1c3c3dbfb01:create

alter table jobtracker.applications
    add constraint applications_interest_rating_ck check ( interest_rating between 1 and 5 ) enable;

-- changeset JOBTRACKER:1794246056115 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/tables/applications.sql
-- sqlcl_snapshot src/database/jobtracker/tables/applications.sql:null:cfc448eaefaa9657f12f70e514e9650bf92b4303:create

alter table jobtracker.applications
    add constraint applications_pk primary key ( application_id )
        using index enable;


-- liquibase formatted sql
-- changeset JOBTRACKER:1793628811930 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/companies.sql
-- sqlcl_snapshot src/database/jobtracker/tables/companies.sql:null:106761333d06886a75bf24e646148030d99a62d6:create

create table jobtracker.companies (
    company_id        number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20 noorder
    nocycle nokeep noscale not null enable,
    company_name      varchar2(200 char) not null enable,
    description       clob,
    note_text         clob,
    parent_company_id number,
    company_type_id   number,
    sector_id         number,
    company_size_id   number,
    location_id       number,
    siren             varchar2(9 char),
    website_url       varchar2(500 char),
    linkedin_slug     varchar2(100 char),
    email             varchar2(254 char),
    phone             varchar2(30 char),
    creation_year     number(4, 0),
    created_at        timestamp(6) with time zone default systimestamp not null enable,
    updated_at        timestamp(6) with time zone default systimestamp not null enable
);

-- changeset JOBTRACKER:1793628811951 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/companies.sql
-- sqlcl_snapshot src/database/jobtracker/tables/companies.sql:null:9d2ada5427347a1ef8d83b8da3927344301d991d:create

alter table jobtracker.companies
    add constraint companies_linkedin_slug_ck check ( regexp_like ( linkedin_slug,
                                                                    '^[^/[:space:]]+$' ) ) enable;

-- changeset JOBTRACKER:1793628811970 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/companies.sql
-- sqlcl_snapshot src/database/jobtracker/tables/companies.sql:null:14223a51c7850dce6eb4b3257a4af3600fbda5ed:create

alter table jobtracker.companies
    add constraint companies_parent_company_id_ck check ( parent_company_id <> company_id ) enable;

-- changeset JOBTRACKER:1793628811986 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/companies.sql
-- sqlcl_snapshot src/database/jobtracker/tables/companies.sql:null:74a5ea9dc47306ca9023edcddffb6182de6bb427:create

alter table jobtracker.companies
    add constraint companies_pk primary key ( company_id )
        using index enable;

-- changeset JOBTRACKER:1793628811995 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/companies.sql
-- sqlcl_snapshot src/database/jobtracker/tables/companies.sql:null:7835ee41d130aa03aaaad37a14f7e393f29b5387:create

alter table jobtracker.companies
    add constraint companies_siren_ck check ( regexp_like ( siren,
                                                            '^[0-9]{9}$' ) ) enable;

-- changeset JOBTRACKER:1793628812001 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/companies.sql
-- sqlcl_snapshot src/database/jobtracker/tables/companies.sql:null:3929a4e9b77ff21a5d8ae68149db1ee40866123f:create

alter table jobtracker.companies add constraint companies_siren_uk unique ( siren )
    using index enable;


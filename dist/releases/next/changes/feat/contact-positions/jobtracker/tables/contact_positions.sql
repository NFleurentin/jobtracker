-- liquibase formatted sql
-- changeset JOBTRACKER:1793796994148 stripComments:false  logicalFilePath:feat/contact-positions/jobtracker/tables/contact_positions.sql
-- sqlcl_snapshot src/database/jobtracker/tables/contact_positions.sql:null:b25ee291d33f793137ee26a28ea59399eced65ff:create

create table jobtracker.contact_positions (
    contact_position_id number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20 noorder
    nocycle nokeep noscale not null enable,
    contact_id          number not null enable,
    company_id          number not null enable,
    job_id              number not null enable,
    is_current          boolean default false not null enable,
    created_at          timestamp(6) with time zone default systimestamp not null enable,
    updated_at          timestamp(6) with time zone default systimestamp not null enable
);

-- changeset JOBTRACKER:1793796994154 stripComments:false  logicalFilePath:feat/contact-positions/jobtracker/tables/contact_positions.sql
-- sqlcl_snapshot src/database/jobtracker/tables/contact_positions.sql:null:45228ac9d1f7e7d8ddd787a9c77c352338981828:create

alter table jobtracker.contact_positions
    add constraint contact_positions_contact_id_company_id_job_id_uk
        unique ( contact_id,
                 company_id,
                 job_id )
            using index enable;

-- changeset JOBTRACKER:1793796994158 stripComments:false  logicalFilePath:feat/contact-positions/jobtracker/tables/contact_positions.sql
-- sqlcl_snapshot src/database/jobtracker/tables/contact_positions.sql:null:5a89e16a4857acb50ef1e173e67ab63a437f2ab1:create

alter table jobtracker.contact_positions
    add constraint contact_positions_pk primary key ( contact_position_id )
        using index enable;


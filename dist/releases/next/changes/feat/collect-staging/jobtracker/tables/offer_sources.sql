-- liquibase formatted sql
-- changeset JOBTRACKER:1793194915972 stripComments:false  logicalFilePath:feat/collect-staging/jobtracker/tables/offer_sources.sql
-- sqlcl_snapshot src/database/jobtracker/tables/offer_sources.sql:null:a4a13b06ba7c443301bf5a6e5b6ddd95c7201581:create

create table jobtracker.offer_sources (
    source_id   number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20 noorder nocycle
    nokeep noscale not null enable,
    source_code varchar2(30 char) not null enable,
    source_name varchar2(100 char) not null enable
);

-- changeset JOBTRACKER:1793194916002 stripComments:false  logicalFilePath:feat/collect-staging/jobtracker/tables/offer_sources.sql
-- sqlcl_snapshot src/database/jobtracker/tables/offer_sources.sql:null:bd6e30ef7a157cc94f7f4ff6ce6e5ca84042d16b:create

alter table jobtracker.offer_sources
    add constraint offer_sources_pk primary key ( source_id )
        using index enable;

-- changeset JOBTRACKER:1793194916018 stripComments:false  logicalFilePath:feat/collect-staging/jobtracker/tables/offer_sources.sql
-- sqlcl_snapshot src/database/jobtracker/tables/offer_sources.sql:null:ac23d499d363e68bc3ffaad9e7b59f288373e838:create

alter table jobtracker.offer_sources add constraint offer_sources_source_code_uk unique ( source_code )
    using index enable;


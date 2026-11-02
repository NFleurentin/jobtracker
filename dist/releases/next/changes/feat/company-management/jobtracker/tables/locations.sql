-- liquibase formatted sql
-- changeset JOBTRACKER:1793628055947 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/locations.sql
-- sqlcl_snapshot src/database/jobtracker/tables/locations.sql:null:5e5556a5a144dcd3d33e25b81d0c4e27e07d172a:create

create table jobtracker.locations (
    location_id        number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20 noorder
    nocycle nokeep noscale not null enable,
    location_type_id   number not null enable,
    parent_location_id number,
    location_code      varchar2(10 char),
    location_name      varchar2(200 char) not null enable,
    longitude          number(9, 6),
    latitude           number(9, 6)
);

-- changeset JOBTRACKER:1793628055965 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/locations.sql
-- sqlcl_snapshot src/database/jobtracker/tables/locations.sql:null:32f626f938f4e90046541e60cfde70a39f37515f:create

alter table jobtracker.locations
    add constraint locations_latitude_ck check ( latitude between - 90 and 90 ) enable;

-- changeset JOBTRACKER:1793628055984 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/locations.sql
-- sqlcl_snapshot src/database/jobtracker/tables/locations.sql:null:589ad6192b7bdbc552dbce63de7b30fc728d88ba:create

alter table jobtracker.locations
    add constraint locations_longitude_ck check ( longitude between - 180 and 180 ) enable;

-- changeset JOBTRACKER:1793628055997 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/locations.sql
-- sqlcl_snapshot src/database/jobtracker/tables/locations.sql:null:9956b7d3b122bc49979b9bf28250f4578953e019:create

alter table jobtracker.locations
    add constraint locations_parent_location_id_ck check ( parent_location_id <> location_id ) enable;

-- changeset JOBTRACKER:1793628056003 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/locations.sql
-- sqlcl_snapshot src/database/jobtracker/tables/locations.sql:null:a508a8e7a3cb5bafe4c42b2e74150cf3343779d9:create

alter table jobtracker.locations
    add constraint locations_parent_location_id_location_name_uk unique ( parent_location_id,
                                                                          location_name )
        using index enable;

-- changeset JOBTRACKER:1793628056007 stripComments:false  logicalFilePath:feat/company-management/jobtracker/tables/locations.sql
-- sqlcl_snapshot src/database/jobtracker/tables/locations.sql:null:b7fad37053735623e9bb661f2f0fb5b99d5470f6:create

alter table jobtracker.locations
    add constraint locations_pk primary key ( location_id )
        using index enable;


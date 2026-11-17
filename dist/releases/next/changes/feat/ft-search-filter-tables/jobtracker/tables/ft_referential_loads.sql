-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337896 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_referential_loads.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_referential_loads.sql:null:3e7fa5d176176afbe047c00ccbf450622e339634:create

create table jobtracker.ft_referential_loads (
    ft_referential_load_id number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20
    noorder nocycle nokeep noscale not null enable,
    started_at             timestamp(6) with time zone default systimestamp not null enable,
    ended_at               timestamp(6) with time zone,
    load_status            varchar2(10 char),
    load_details           json
);

-- changeset JOBTRACKER:1794922337970 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_referential_loads.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_referential_loads.sql:null:2bb93fe7a0f034353236b0986bb4836cb523d352:create

alter table jobtracker.ft_referential_loads
    add constraint ft_referential_loads_dates_ck check ( ended_at >= started_at ) enable;

-- changeset JOBTRACKER:1794922338004 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_referential_loads.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_referential_loads.sql:null:e819a79b0f3e7328fdd97756c7664ed457c3e645:create

alter table jobtracker.ft_referential_loads
    add constraint ft_referential_loads_end_ck
        check ( ( ended_at is null
                  and load_status is null )
                or ( ended_at is not null
                     and load_status is not null ) ) enable;

-- changeset JOBTRACKER:1794922338014 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_referential_loads.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_referential_loads.sql:null:468247347c7fcb452fcf5e82a4a627f744c5c6c6:create

alter table jobtracker.ft_referential_loads
    add constraint ft_referential_loads_load_status_ck
        check ( load_status in ( 'SUCCESS', 'PARTIAL', 'ERROR' ) ) enable;

-- changeset JOBTRACKER:1794922338017 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_referential_loads.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_referential_loads.sql:null:2aa0d6ebf9b53415bf0b5fe94e361f64257d5f71:create

alter table jobtracker.ft_referential_loads
    add constraint ft_referential_loads_pk primary key ( ft_referential_load_id )
        using index enable;


-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337900 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_regions.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_regions.sql:null:cb05bb87bf397ad5a94c216fe10c4a57eab74834:create

create table jobtracker.ft_regions (
    region_id              number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20
    noorder nocycle nokeep noscale not null enable,
    region_code            varchar2(10 char) not null enable,
    region_name            varchar2(100 char) not null enable,
    ft_referential_load_id number not null enable
);

-- changeset JOBTRACKER:1794922337973 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_regions.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_regions.sql:null:3d45f924e8f5d86aaaa6f59689009325e40bfc79:create

alter table jobtracker.ft_regions
    add constraint ft_regions_pk primary key ( region_id )
        using index enable;

-- changeset JOBTRACKER:1794922338008 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/tables/ft_regions.sql
-- sqlcl_snapshot src/database/jobtracker/tables/ft_regions.sql:null:f547aad716be4fd0e3fddcc5383833ce544987f5:create

alter table jobtracker.ft_regions add constraint ft_regions_region_code_uk unique ( region_code )
    using index enable;


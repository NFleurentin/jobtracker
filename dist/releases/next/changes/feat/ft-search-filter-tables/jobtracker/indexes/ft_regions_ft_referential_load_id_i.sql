-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337818 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/indexes/ft_regions_ft_referential_load_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/ft_regions_ft_referential_load_id_i.sql:null:5a273dd56d0a2b952043314e9bbc56e8c3e10426:create

create index jobtracker.ft_regions_ft_referential_load_id_i on
    jobtracker.ft_regions (
        ft_referential_load_id
    );


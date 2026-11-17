-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337821 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/indexes/ft_continents_ft_referential_load_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/ft_continents_ft_referential_load_id_i.sql:null:2514ce64dd874577d0ae830a898d2f8b5e8cdb9a:create

create index jobtracker.ft_continents_ft_referential_load_id_i on
    jobtracker.ft_continents (
        ft_referential_load_id
    );


-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337803 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/indexes/ft_countries_ft_referential_load_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/ft_countries_ft_referential_load_id_i.sql:null:fe076a613335ab2c10aafeb7e4c5608fb477a094:create

create index jobtracker.ft_countries_ft_referential_load_id_i on
    jobtracker.ft_countries (
        ft_referential_load_id
    );


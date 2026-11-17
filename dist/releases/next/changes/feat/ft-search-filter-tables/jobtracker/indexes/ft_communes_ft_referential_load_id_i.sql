-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337824 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/indexes/ft_communes_ft_referential_load_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/ft_communes_ft_referential_load_id_i.sql:null:fbdffb819df22beb20a9088886177bf982e1575d:create

create index jobtracker.ft_communes_ft_referential_load_id_i on
    jobtracker.ft_communes (
        ft_referential_load_id
    );


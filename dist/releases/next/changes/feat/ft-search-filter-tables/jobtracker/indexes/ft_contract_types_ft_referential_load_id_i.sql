-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337813 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/indexes/ft_contract_types_ft_referential_load_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/ft_contract_types_ft_referential_load_id_i.sql:null:251c72037b4ddef5ccbdc6170528f3124f92ff49:create

create index jobtracker.ft_contract_types_ft_referential_load_id_i on
    jobtracker.ft_contract_types (
        ft_referential_load_id
    );


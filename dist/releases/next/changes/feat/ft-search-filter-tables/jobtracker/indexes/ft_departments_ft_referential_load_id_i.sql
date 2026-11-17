-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337826 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/indexes/ft_departments_ft_referential_load_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/ft_departments_ft_referential_load_id_i.sql:null:b62a74243897635f8fed84a0b0431b3f8ab93789:create

create index jobtracker.ft_departments_ft_referential_load_id_i on
    jobtracker.ft_departments (
        ft_referential_load_id
    );


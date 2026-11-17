-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337800 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/indexes/ft_communes_department_code_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/ft_communes_department_code_i.sql:null:9204b7403a3ade5c73a05bca2b78b3875b008734:create

create index jobtracker.ft_communes_department_code_i on
    jobtracker.ft_communes (
        department_code
    );


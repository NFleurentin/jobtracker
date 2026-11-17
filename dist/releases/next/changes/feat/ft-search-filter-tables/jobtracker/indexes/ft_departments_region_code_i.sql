-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337808 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/indexes/ft_departments_region_code_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/ft_departments_region_code_i.sql:null:2ddf33dc37b82b36b2fff661100daa719896086f:create

create index jobtracker.ft_departments_region_code_i on
    jobtracker.ft_departments (
        region_code
    );


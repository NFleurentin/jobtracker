-- liquibase formatted sql
-- changeset JOBTRACKER:1793628811884 stripComments:false  logicalFilePath:feat/company-management/jobtracker/indexes/companies_sector_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/companies_sector_id_i.sql:null:865af9d891319064d491591ab290c235ae6d08b0:create

create index jobtracker.companies_sector_id_i on
    jobtracker.companies (
        sector_id
    );


-- liquibase formatted sql
-- changeset JOBTRACKER:1794243864730 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/indexes/companies_is_generic_uk.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/companies_is_generic_uk.sql:null:b389b06ac686efda9baac69ad752f51af49e168b:create

create unique index jobtracker.companies_is_generic_uk on
    jobtracker.companies (
        case
            when
                is_generic
            = true then
                1
        end
    );


-- liquibase formatted sql
-- changeset JOBTRACKER:1794243865029 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/tables/companies.sql
-- sqlcl_snapshot src/database/jobtracker/tables/companies.sql:d4146e00feeb85a65cabde8832f520cbb8949ab0:599e55877ec32ed97cc5348c135ca642e7903d47:alter

alter table jobtracker.companies add (
    is_generic boolean default false not null enable
)
/


-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337852 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/ref_constraints/ft_departments_ft_regions_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/ft_departments_ft_regions_fk.sql:null:3c4859f5f35265e9ba38babae43635a48ffa1ed7:create

alter table jobtracker.ft_departments
    add constraint ft_departments_ft_regions_fk
        foreign key ( region_code )
            references jobtracker.ft_regions ( region_code )
        enable;


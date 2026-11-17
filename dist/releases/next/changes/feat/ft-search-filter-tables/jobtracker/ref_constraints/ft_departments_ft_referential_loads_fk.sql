-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337849 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/ref_constraints/ft_departments_ft_referential_loads_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/ft_departments_ft_referential_loads_fk.sql:null:192dacbf0eac575b0847c68d360f8b1b0bae7a4a:create

alter table jobtracker.ft_departments
    add constraint ft_departments_ft_referential_loads_fk
        foreign key ( ft_referential_load_id )
            references jobtracker.ft_referential_loads ( ft_referential_load_id )
        enable;


-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337845 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/ref_constraints/ft_countries_ft_referential_loads_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/ft_countries_ft_referential_loads_fk.sql:null:f8ebe77cee8a40168d6adcd21e5e0123db312c17:create

alter table jobtracker.ft_countries
    add constraint ft_countries_ft_referential_loads_fk
        foreign key ( ft_referential_load_id )
            references jobtracker.ft_referential_loads ( ft_referential_load_id )
        enable;


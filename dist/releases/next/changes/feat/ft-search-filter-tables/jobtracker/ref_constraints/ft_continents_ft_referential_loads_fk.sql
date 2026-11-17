-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337832 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/ref_constraints/ft_continents_ft_referential_loads_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/ft_continents_ft_referential_loads_fk.sql:null:44374c2db330270be0d076b8424528fdee1f8b9e:create

alter table jobtracker.ft_continents
    add constraint ft_continents_ft_referential_loads_fk
        foreign key ( ft_referential_load_id )
            references jobtracker.ft_referential_loads ( ft_referential_load_id )
        enable;


-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337856 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/ref_constraints/ft_regions_ft_referential_loads_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/ft_regions_ft_referential_loads_fk.sql:null:bb337fffaa2300c2976f4ba9af2770c8f12c68f5:create

alter table jobtracker.ft_regions
    add constraint ft_regions_ft_referential_loads_fk
        foreign key ( ft_referential_load_id )
            references jobtracker.ft_referential_loads ( ft_referential_load_id )
        enable;


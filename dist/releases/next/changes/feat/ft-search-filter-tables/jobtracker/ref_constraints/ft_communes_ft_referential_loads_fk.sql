-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337838 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/ref_constraints/ft_communes_ft_referential_loads_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/ft_communes_ft_referential_loads_fk.sql:null:4e9fa11412c07acb198451bada75840dd029e948:create

alter table jobtracker.ft_communes
    add constraint ft_communes_ft_referential_loads_fk
        foreign key ( ft_referential_load_id )
            references jobtracker.ft_referential_loads ( ft_referential_load_id )
        enable;


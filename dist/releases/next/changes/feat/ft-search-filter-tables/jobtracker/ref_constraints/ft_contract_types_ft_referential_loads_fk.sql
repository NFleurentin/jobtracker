-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337835 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/ref_constraints/ft_contract_types_ft_referential_loads_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/ft_contract_types_ft_referential_loads_fk.sql:null:3208cea3228bd30583659170c9a3653b9176d00f:create

alter table jobtracker.ft_contract_types
    add constraint ft_contract_types_ft_referential_loads_fk
        foreign key ( ft_referential_load_id )
            references jobtracker.ft_referential_loads ( ft_referential_load_id )
        enable;


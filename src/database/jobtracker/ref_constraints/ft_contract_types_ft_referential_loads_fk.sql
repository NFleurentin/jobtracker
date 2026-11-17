alter table jobtracker.ft_contract_types
    add constraint ft_contract_types_ft_referential_loads_fk
        foreign key ( ft_referential_load_id )
            references jobtracker.ft_referential_loads ( ft_referential_load_id )
        enable;


-- sqlcl_snapshot {"hash":"3208cea3228bd30583659170c9a3653b9176d00f","type":"REF_CONSTRAINT","name":"FT_CONTRACT_TYPES_FT_REFERENTIAL_LOADS_FK","schemaName":"JOBTRACKER","sxml":""}
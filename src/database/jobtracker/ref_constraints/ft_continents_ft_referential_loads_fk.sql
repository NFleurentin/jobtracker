alter table jobtracker.ft_continents
    add constraint ft_continents_ft_referential_loads_fk
        foreign key ( ft_referential_load_id )
            references jobtracker.ft_referential_loads ( ft_referential_load_id )
        enable;


-- sqlcl_snapshot {"hash":"44374c2db330270be0d076b8424528fdee1f8b9e","type":"REF_CONSTRAINT","name":"FT_CONTINENTS_FT_REFERENTIAL_LOADS_FK","schemaName":"JOBTRACKER","sxml":""}
alter table jobtracker.ft_countries
    add constraint ft_countries_ft_referential_loads_fk
        foreign key ( ft_referential_load_id )
            references jobtracker.ft_referential_loads ( ft_referential_load_id )
        enable;


-- sqlcl_snapshot {"hash":"f8ebe77cee8a40168d6adcd21e5e0123db312c17","type":"REF_CONSTRAINT","name":"FT_COUNTRIES_FT_REFERENTIAL_LOADS_FK","schemaName":"JOBTRACKER","sxml":""}
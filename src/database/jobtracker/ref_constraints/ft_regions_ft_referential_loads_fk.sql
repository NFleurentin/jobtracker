alter table jobtracker.ft_regions
    add constraint ft_regions_ft_referential_loads_fk
        foreign key ( ft_referential_load_id )
            references jobtracker.ft_referential_loads ( ft_referential_load_id )
        enable;


-- sqlcl_snapshot {"hash":"bb337fffaa2300c2976f4ba9af2770c8f12c68f5","type":"REF_CONSTRAINT","name":"FT_REGIONS_FT_REFERENTIAL_LOADS_FK","schemaName":"JOBTRACKER","sxml":""}
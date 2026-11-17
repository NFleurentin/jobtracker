alter table jobtracker.ft_communes
    add constraint ft_communes_ft_referential_loads_fk
        foreign key ( ft_referential_load_id )
            references jobtracker.ft_referential_loads ( ft_referential_load_id )
        enable;


-- sqlcl_snapshot {"hash":"4e9fa11412c07acb198451bada75840dd029e948","type":"REF_CONSTRAINT","name":"FT_COMMUNES_FT_REFERENTIAL_LOADS_FK","schemaName":"JOBTRACKER","sxml":""}
alter table jobtracker.ft_departments
    add constraint ft_departments_ft_referential_loads_fk
        foreign key ( ft_referential_load_id )
            references jobtracker.ft_referential_loads ( ft_referential_load_id )
        enable;


-- sqlcl_snapshot {"hash":"192dacbf0eac575b0847c68d360f8b1b0bae7a4a","type":"REF_CONSTRAINT","name":"FT_DEPARTMENTS_FT_REFERENTIAL_LOADS_FK","schemaName":"JOBTRACKER","sxml":""}
alter table jobtracker.ft_departments
    add constraint ft_departments_ft_regions_fk
        foreign key ( region_code )
            references jobtracker.ft_regions ( region_code )
        enable;


-- sqlcl_snapshot {"hash":"3c4859f5f35265e9ba38babae43635a48ffa1ed7","type":"REF_CONSTRAINT","name":"FT_DEPARTMENTS_FT_REGIONS_FK","schemaName":"JOBTRACKER","sxml":""}
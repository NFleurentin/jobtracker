alter table jobtracker.ft_communes
    add constraint ft_communes_ft_departments_fk
        foreign key ( department_code )
            references jobtracker.ft_departments ( department_code )
        enable;


-- sqlcl_snapshot {"hash":"358ae72c133fee48f8789d4aee061569f6683035","type":"REF_CONSTRAINT","name":"FT_COMMUNES_FT_DEPARTMENTS_FK","schemaName":"JOBTRACKER","sxml":""}
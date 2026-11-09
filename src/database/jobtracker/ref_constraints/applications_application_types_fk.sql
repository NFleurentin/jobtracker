alter table jobtracker.applications
    add constraint applications_application_types_fk
        foreign key ( application_type_id )
            references jobtracker.application_types ( application_type_id )
        enable;


-- sqlcl_snapshot {"hash":"13a4f7910ba3058549b8518c597bb481fec9e9a9","type":"REF_CONSTRAINT","name":"APPLICATIONS_APPLICATION_TYPES_FK","schemaName":"JOBTRACKER","sxml":""}
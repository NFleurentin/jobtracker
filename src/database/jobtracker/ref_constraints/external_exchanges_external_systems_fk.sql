alter table jobtracker.external_exchanges
    add constraint external_exchanges_external_systems_fk
        foreign key ( external_system_id )
            references jobtracker.external_systems ( external_system_id )
        enable;


-- sqlcl_snapshot {"hash":"f7ac9a08496a9c7c7e0685d47752b9ceb546c9c5","type":"REF_CONSTRAINT","name":"EXTERNAL_EXCHANGES_EXTERNAL_SYSTEMS_FK","schemaName":"JOBTRACKER","sxml":""}
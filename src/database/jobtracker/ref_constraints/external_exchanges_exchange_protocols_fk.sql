alter table jobtracker.external_exchanges
    add constraint external_exchanges_exchange_protocols_fk
        foreign key ( exchange_protocol_id )
            references jobtracker.exchange_protocols ( exchange_protocol_id )
        enable;


-- sqlcl_snapshot {"hash":"010addfa323cfc8fe6536b27ed0a381ed7bb2cdc","type":"REF_CONSTRAINT","name":"EXTERNAL_EXCHANGES_EXCHANGE_PROTOCOLS_FK","schemaName":"JOBTRACKER","sxml":""}
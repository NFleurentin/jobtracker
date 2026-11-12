alter table jobtracker.external_exchanges
    add constraint external_exchanges_exchange_statuses_fk
        foreign key ( exchange_status_id )
            references jobtracker.exchange_statuses ( exchange_status_id )
        enable;


-- sqlcl_snapshot {"hash":"a7c5097ba0d366af1e4051a59132720d71737a32","type":"REF_CONSTRAINT","name":"EXTERNAL_EXCHANGES_EXCHANGE_STATUSES_FK","schemaName":"JOBTRACKER","sxml":""}
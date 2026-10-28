alter table jobtracker.collect_runs
    add constraint collect_runs_offer_sources_fk
        foreign key ( source_id )
            references jobtracker.offer_sources ( source_id )
        enable;


-- sqlcl_snapshot {"hash":"ba1f09772a6b1f6180d8db153b2edf8c95ead65a","type":"REF_CONSTRAINT","name":"COLLECT_RUNS_OFFER_SOURCES_FK","schemaName":"JOBTRACKER","sxml":""}
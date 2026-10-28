alter table jobtracker.collect_requests
    add constraint collect_requests_collect_runs_fk
        foreign key ( run_id )
            references jobtracker.collect_runs ( run_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"3598f18a527ffddd2904799e0c99041fe34ed1a8","type":"REF_CONSTRAINT","name":"COLLECT_REQUESTS_COLLECT_RUNS_FK","schemaName":"JOBTRACKER","sxml":""}
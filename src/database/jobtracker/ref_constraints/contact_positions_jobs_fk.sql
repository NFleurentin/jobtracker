alter table jobtracker.contact_positions
    add constraint contact_positions_jobs_fk
        foreign key ( job_id )
            references jobtracker.jobs ( job_id )
        enable;


-- sqlcl_snapshot {"hash":"ae35d323bdca829a8630a032fbd867d898a16ad0","type":"REF_CONSTRAINT","name":"CONTACT_POSITIONS_JOBS_FK","schemaName":"JOBTRACKER","sxml":""}
begin
    dbms_scheduler.create_job(
        job_name            => 'JOBTRACKER.EXCHANGE_LOG_HOUSEKEEPING',
        job_type            => 'STORED_PROCEDURE',
        job_action          => 'EXCHANGE_LOG.RUN_HOUSEKEEPING',
        start_date          => timestamp '2026-11-12 16:19:51.332947',
        repeat_interval     => 'FREQ=DAILY;BYHOUR=3;BYMINUTE=0;BYSECOND=0',
        end_date            => null,
        job_class           => 'DEFAULT_JOB_CLASS',
        comments            => 'Entretien quotidien du journal des échanges : exchange_log.run_housekeeping',
        auto_drop           => true,
        number_of_arguments => 0
    );

    dbms_scheduler.set_attribute(
        name      => 'JOBTRACKER.EXCHANGE_LOG_HOUSEKEEPING',
        attribute => 'logging_level',
        value     => dbms_scheduler.logging_off
    );

    dbms_scheduler.set_attribute(
        name      => 'JOBTRACKER.EXCHANGE_LOG_HOUSEKEEPING',
        attribute => 'job_priority',
        value     => 3
    );

    dbms_scheduler.enable('JOBTRACKER.EXCHANGE_LOG_HOUSEKEEPING');
end;
/


-- sqlcl_snapshot {"hash":"142a0b50d77e803c69b5ecf8b8a9120b7b1ca3dc","type":"JOB","name":"EXCHANGE_LOG_HOUSEKEEPING","schemaName":"JOBTRACKER","sxml":""}
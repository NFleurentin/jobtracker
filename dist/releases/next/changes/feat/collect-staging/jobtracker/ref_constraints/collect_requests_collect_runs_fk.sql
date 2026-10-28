-- liquibase formatted sql
-- changeset JOBTRACKER:1793194915963 stripComments:false  logicalFilePath:feat/collect-staging/jobtracker/ref_constraints/collect_requests_collect_runs_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/collect_requests_collect_runs_fk.sql:null:3598f18a527ffddd2904799e0c99041fe34ed1a8:create

alter table jobtracker.collect_requests
    add constraint collect_requests_collect_runs_fk
        foreign key ( run_id )
            references jobtracker.collect_runs ( run_id )
                on delete cascade
        enable;


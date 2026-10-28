-- liquibase formatted sql
-- changeset JOBTRACKER:1793194915958 stripComments:false  logicalFilePath:feat/collect-staging/jobtracker/ref_constraints/collect_runs_offer_sources_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/collect_runs_offer_sources_fk.sql:null:ba1f09772a6b1f6180d8db153b2edf8c95ead65a:create

alter table jobtracker.collect_runs
    add constraint collect_runs_offer_sources_fk
        foreign key ( source_id )
            references jobtracker.offer_sources ( source_id )
        enable;


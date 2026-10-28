-- liquibase formatted sql
-- changeset JOBTRACKER:1793194915951 stripComments:false  logicalFilePath:feat/collect-staging/jobtracker/indexes/collect_runs_source_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/collect_runs_source_id_i.sql:null:3ed0445b557022078f21470623f2fb9d2222cbb3:create

create index jobtracker.collect_runs_source_id_i on
    jobtracker.collect_runs (
        source_id
    );


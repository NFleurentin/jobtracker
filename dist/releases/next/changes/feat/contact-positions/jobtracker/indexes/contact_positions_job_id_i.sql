-- liquibase formatted sql
-- changeset JOBTRACKER:1793796994124 stripComments:false  logicalFilePath:feat/contact-positions/jobtracker/indexes/contact_positions_job_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/contact_positions_job_id_i.sql:null:812e754265dc1c9a20a4783814ae160de5fb8e8f:create

create index jobtracker.contact_positions_job_id_i on
    jobtracker.contact_positions (
        job_id
    );


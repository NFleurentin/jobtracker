-- liquibase formatted sql
-- changeset JOBTRACKER:1793796994134 stripComments:false  logicalFilePath:feat/contact-positions/jobtracker/ref_constraints/contact_positions_jobs_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/contact_positions_jobs_fk.sql:null:ae35d323bdca829a8630a032fbd867d898a16ad0:create

alter table jobtracker.contact_positions
    add constraint contact_positions_jobs_fk
        foreign key ( job_id )
            references jobtracker.jobs ( job_id )
        enable;


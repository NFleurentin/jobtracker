-- liquibase formatted sql
-- changeset JOBTRACKER:1793738246416 stripComments:false  logicalFilePath:feat/contacts-data-model/jobtracker/indexes/contacts_salutation_id_i.sql
-- sqlcl_snapshot src/database/jobtracker/indexes/contacts_salutation_id_i.sql:null:f7ab99d9202635db9cb646584cd06d305fba2867:create

create index jobtracker.contacts_salutation_id_i on
    jobtracker.contacts (
        salutation_id
    );


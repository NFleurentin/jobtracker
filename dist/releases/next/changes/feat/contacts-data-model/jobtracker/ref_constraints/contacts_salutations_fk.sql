-- liquibase formatted sql
-- changeset JOBTRACKER:1793738246429 stripComments:false  logicalFilePath:feat/contacts-data-model/jobtracker/ref_constraints/contacts_salutations_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/contacts_salutations_fk.sql:null:6f0e9a62eb71131f27b8a2aee2d161267f45884e:create

alter table jobtracker.contacts
    add constraint contacts_salutations_fk
        foreign key ( salutation_id )
            references jobtracker.salutations ( salutation_id )
        enable;


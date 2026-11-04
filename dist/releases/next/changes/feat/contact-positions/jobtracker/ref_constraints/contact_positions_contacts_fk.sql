-- liquibase formatted sql
-- changeset JOBTRACKER:1793796994129 stripComments:false  logicalFilePath:feat/contact-positions/jobtracker/ref_constraints/contact_positions_contacts_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/contact_positions_contacts_fk.sql:null:1e9f14a38f74cd4bc3733f477b7b5f0149e8aa01:create

alter table jobtracker.contact_positions
    add constraint contact_positions_contacts_fk
        foreign key ( contact_id )
            references jobtracker.contacts ( contact_id )
        enable;


alter table jobtracker.contact_positions
    add constraint contact_positions_contacts_fk
        foreign key ( contact_id )
            references jobtracker.contacts ( contact_id )
        enable;


-- sqlcl_snapshot {"hash":"1e9f14a38f74cd4bc3733f477b7b5f0149e8aa01","type":"REF_CONSTRAINT","name":"CONTACT_POSITIONS_CONTACTS_FK","schemaName":"JOBTRACKER","sxml":""}
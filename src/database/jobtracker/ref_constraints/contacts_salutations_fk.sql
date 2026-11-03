alter table jobtracker.contacts
    add constraint contacts_salutations_fk
        foreign key ( salutation_id )
            references jobtracker.salutations ( salutation_id )
        enable;


-- sqlcl_snapshot {"hash":"6f0e9a62eb71131f27b8a2aee2d161267f45884e","type":"REF_CONSTRAINT","name":"CONTACTS_SALUTATIONS_FK","schemaName":"JOBTRACKER","sxml":""}
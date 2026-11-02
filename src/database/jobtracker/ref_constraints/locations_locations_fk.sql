alter table jobtracker.locations
    add constraint locations_locations_fk
        foreign key ( parent_location_id )
            references jobtracker.locations ( location_id )
        enable;


-- sqlcl_snapshot {"hash":"6f3e9f1a52eaef21e61056dfe5cb7d9107221e30","type":"REF_CONSTRAINT","name":"LOCATIONS_LOCATIONS_FK","schemaName":"JOBTRACKER","sxml":""}
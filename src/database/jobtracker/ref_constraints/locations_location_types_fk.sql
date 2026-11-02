alter table jobtracker.locations
    add constraint locations_location_types_fk
        foreign key ( location_type_id )
            references jobtracker.location_types ( location_type_id )
        enable;


-- sqlcl_snapshot {"hash":"be4ab3dd4560076a338da0d941b2c3f98a909d7d","type":"REF_CONSTRAINT","name":"LOCATIONS_LOCATION_TYPES_FK","schemaName":"JOBTRACKER","sxml":""}
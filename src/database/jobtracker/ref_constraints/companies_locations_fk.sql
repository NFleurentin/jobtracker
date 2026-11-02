alter table jobtracker.companies
    add constraint companies_locations_fk
        foreign key ( location_id )
            references jobtracker.locations ( location_id )
        enable;


-- sqlcl_snapshot {"hash":"354d1036ebc52ed398e1d6a47c3d0e86a254bc04","type":"REF_CONSTRAINT","name":"COMPANIES_LOCATIONS_FK","schemaName":"JOBTRACKER","sxml":""}
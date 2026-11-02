alter table jobtracker.companies
    add constraint companies_sectors_fk
        foreign key ( sector_id )
            references jobtracker.sectors ( sector_id )
        enable;


-- sqlcl_snapshot {"hash":"f91782b17b458dddd42d9dde0830987dc3934ade","type":"REF_CONSTRAINT","name":"COMPANIES_SECTORS_FK","schemaName":"JOBTRACKER","sxml":""}
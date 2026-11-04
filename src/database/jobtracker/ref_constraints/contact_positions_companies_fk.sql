alter table jobtracker.contact_positions
    add constraint contact_positions_companies_fk
        foreign key ( company_id )
            references jobtracker.companies ( company_id )
        enable;


-- sqlcl_snapshot {"hash":"a9aa72b91c2e3552126be7bd608ea11c67077706","type":"REF_CONSTRAINT","name":"CONTACT_POSITIONS_COMPANIES_FK","schemaName":"JOBTRACKER","sxml":""}
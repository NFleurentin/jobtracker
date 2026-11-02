alter table jobtracker.companies
    add constraint companies_company_sizes_fk
        foreign key ( company_size_id )
            references jobtracker.company_sizes ( company_size_id )
        enable;


-- sqlcl_snapshot {"hash":"5d88daf78e725a384ddf2245077c2d980b21682d","type":"REF_CONSTRAINT","name":"COMPANIES_COMPANY_SIZES_FK","schemaName":"JOBTRACKER","sxml":""}
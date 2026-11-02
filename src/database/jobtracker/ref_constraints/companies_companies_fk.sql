alter table jobtracker.companies
    add constraint companies_companies_fk
        foreign key ( parent_company_id )
            references jobtracker.companies ( company_id )
        enable;


-- sqlcl_snapshot {"hash":"e9fa0f97b44fceb2db5ea08ffe44b47798f0b804","type":"REF_CONSTRAINT","name":"COMPANIES_COMPANIES_FK","schemaName":"JOBTRACKER","sxml":""}
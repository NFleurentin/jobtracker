alter table jobtracker.applications
    add constraint applications_companies_fk
        foreign key ( company_id )
            references jobtracker.companies ( company_id )
        enable;


-- sqlcl_snapshot {"hash":"1afd4ba3b4106147e6333dab70564943f331cb86","type":"REF_CONSTRAINT","name":"APPLICATIONS_COMPANIES_FK","schemaName":"JOBTRACKER","sxml":""}
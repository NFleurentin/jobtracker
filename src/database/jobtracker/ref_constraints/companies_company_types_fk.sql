alter table jobtracker.companies
    add constraint companies_company_types_fk
        foreign key ( company_type_id )
            references jobtracker.company_types ( company_type_id )
        enable;


-- sqlcl_snapshot {"hash":"bad8c77e937e67ca446f8bfa808b1b1cd29e3504","type":"REF_CONSTRAINT","name":"COMPANIES_COMPANY_TYPES_FK","schemaName":"JOBTRACKER","sxml":""}
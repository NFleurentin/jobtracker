create index jobtracker.companies_company_type_id_i on
    jobtracker.companies (
        company_type_id
    );


-- sqlcl_snapshot {"hash":"054902dfca44b2cb24152887009f731e5d9094ee","type":"INDEX","name":"COMPANIES_COMPANY_TYPE_ID_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>COMPANIES_COMPANY_TYPE_ID_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>COMPANIES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>COMPANY_TYPE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
create index jobtracker.companies_company_size_id_i on
    jobtracker.companies (
        company_size_id
    );


-- sqlcl_snapshot {"hash":"184c462a00fa43fb23793788538790f7c49d49c9","type":"INDEX","name":"COMPANIES_COMPANY_SIZE_ID_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>COMPANIES_COMPANY_SIZE_ID_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>COMPANIES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>COMPANY_SIZE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
create index jobtracker.companies_parent_company_id_i on
    jobtracker.companies (
        parent_company_id
    );


-- sqlcl_snapshot {"hash":"c17b3cff47a5384eefbae715e379beae7ccf6442","type":"INDEX","name":"COMPANIES_PARENT_COMPANY_ID_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>COMPANIES_PARENT_COMPANY_ID_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>COMPANIES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PARENT_COMPANY_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
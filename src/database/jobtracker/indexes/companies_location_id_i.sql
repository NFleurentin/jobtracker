create index jobtracker.companies_location_id_i on
    jobtracker.companies (
        location_id
    );


-- sqlcl_snapshot {"hash":"7b00500c3f0f475345ce8a306ccf4b47c5247461","type":"INDEX","name":"COMPANIES_LOCATION_ID_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>COMPANIES_LOCATION_ID_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>COMPANIES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LOCATION_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
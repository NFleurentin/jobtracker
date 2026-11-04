create index jobtracker.contact_positions_company_id_i on
    jobtracker.contact_positions (
        company_id
    );


-- sqlcl_snapshot {"hash":"cb73c721f41a90bcb6bc6189572d4e45d5c88956","type":"INDEX","name":"CONTACT_POSITIONS_COMPANY_ID_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>CONTACT_POSITIONS_COMPANY_ID_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>CONTACT_POSITIONS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>COMPANY_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
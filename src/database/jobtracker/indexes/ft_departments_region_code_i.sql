create index jobtracker.ft_departments_region_code_i on
    jobtracker.ft_departments (
        region_code
    );


-- sqlcl_snapshot {"hash":"2ddf33dc37b82b36b2fff661100daa719896086f","type":"INDEX","name":"FT_DEPARTMENTS_REGION_CODE_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>FT_DEPARTMENTS_REGION_CODE_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>FT_DEPARTMENTS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>REGION_CODE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
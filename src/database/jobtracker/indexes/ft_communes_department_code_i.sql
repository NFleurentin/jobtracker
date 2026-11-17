create index jobtracker.ft_communes_department_code_i on
    jobtracker.ft_communes (
        department_code
    );


-- sqlcl_snapshot {"hash":"9204b7403a3ade5c73a05bca2b78b3875b008734","type":"INDEX","name":"FT_COMMUNES_DEPARTMENT_CODE_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>FT_COMMUNES_DEPARTMENT_CODE_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>FT_COMMUNES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>DEPARTMENT_CODE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
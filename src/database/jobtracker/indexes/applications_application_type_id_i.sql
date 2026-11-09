create index jobtracker.applications_application_type_id_i on
    jobtracker.applications (
        application_type_id
    );


-- sqlcl_snapshot {"hash":"09f29c199377a481f95d78570fb4129766d7849f","type":"INDEX","name":"APPLICATIONS_APPLICATION_TYPE_ID_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>APPLICATIONS_APPLICATION_TYPE_ID_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>APPLICATIONS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>APPLICATION_TYPE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
create index jobtracker.application_status_changes_application_status_id_i on
    jobtracker.application_status_changes (
        application_status_id
    );


-- sqlcl_snapshot {"hash":"8d578b1105f9f44f31de0ddf4bb72eb286c882ec","type":"INDEX","name":"APPLICATION_STATUS_CHANGES_APPLICATION_STATUS_ID_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>APPLICATION_STATUS_CHANGES_APPLICATION_STATUS_ID_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>APPLICATION_STATUS_CHANGES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>APPLICATION_STATUS_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
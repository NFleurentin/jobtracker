create index jobtracker.application_status_changes_application_id_changed_at_application_status_change_id_i on
    jobtracker.application_status_changes (
        application_id,
    sys_extract_utc(changed_at),
        application_status_change_id
    );


-- sqlcl_snapshot {"hash":"db3f12ff83d9f1aa9b5b56d05b423fe57c987226","type":"INDEX","name":"APPLICATION_STATUS_CHANGES_APPLICATION_ID_CHANGED_AT_APPLICATION_STATUS_CHANGE_ID_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>APPLICATION_STATUS_CHANGES_APPLICATION_ID_CHANGED_AT_APPLICATION_STATUS_CHANGE_ID_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>APPLICATION_STATUS_CHANGES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>APPLICATION_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <DEFAULT_EXPRESSION>SYS_EXTRACT_UTC(\"CHANGED_AT\")</DEFAULT_EXPRESSION>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APPLICATION_STATUS_CHANGE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
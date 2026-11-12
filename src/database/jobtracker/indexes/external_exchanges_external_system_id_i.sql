create index jobtracker.external_exchanges_external_system_id_i on
    jobtracker.external_exchanges (
        external_system_id
    );


-- sqlcl_snapshot {"hash":"a373aba7d3bbb73bb16f09c196b694fd6c6f809b","type":"INDEX","name":"EXTERNAL_EXCHANGES_EXTERNAL_SYSTEM_ID_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>EXTERNAL_EXCHANGES_EXTERNAL_SYSTEM_ID_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>EXTERNAL_EXCHANGES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>EXTERNAL_SYSTEM_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
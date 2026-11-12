create index jobtracker.external_exchanges_exchange_status_id_i on
    jobtracker.external_exchanges (
        exchange_status_id
    );


-- sqlcl_snapshot {"hash":"64b7861e45203e186f6733b2d8a46ac453f723ac","type":"INDEX","name":"EXTERNAL_EXCHANGES_EXCHANGE_STATUS_ID_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>EXTERNAL_EXCHANGES_EXCHANGE_STATUS_ID_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>EXTERNAL_EXCHANGES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>EXCHANGE_STATUS_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
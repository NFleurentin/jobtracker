create index jobtracker.external_exchanges_exchange_protocol_id_i on
    jobtracker.external_exchanges (
        exchange_protocol_id
    );


-- sqlcl_snapshot {"hash":"249ed5642482478f7d3ccbd6cc266b8044135821","type":"INDEX","name":"EXTERNAL_EXCHANGES_EXCHANGE_PROTOCOL_ID_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>EXTERNAL_EXCHANGES_EXCHANGE_PROTOCOL_ID_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>EXTERNAL_EXCHANGES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>EXCHANGE_PROTOCOL_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
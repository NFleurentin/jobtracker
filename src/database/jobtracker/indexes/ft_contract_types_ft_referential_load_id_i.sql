create index jobtracker.ft_contract_types_ft_referential_load_id_i on
    jobtracker.ft_contract_types (
        ft_referential_load_id
    );


-- sqlcl_snapshot {"hash":"251c72037b4ddef5ccbdc6170528f3124f92ff49","type":"INDEX","name":"FT_CONTRACT_TYPES_FT_REFERENTIAL_LOAD_ID_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>FT_CONTRACT_TYPES_FT_REFERENTIAL_LOAD_ID_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>FT_CONTRACT_TYPES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FT_REFERENTIAL_LOAD_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
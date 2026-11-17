create index jobtracker.ft_communes_ft_referential_load_id_i on
    jobtracker.ft_communes (
        ft_referential_load_id
    );


-- sqlcl_snapshot {"hash":"fbdffb819df22beb20a9088886177bf982e1575d","type":"INDEX","name":"FT_COMMUNES_FT_REFERENTIAL_LOAD_ID_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>FT_COMMUNES_FT_REFERENTIAL_LOAD_ID_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>FT_COMMUNES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FT_REFERENTIAL_LOAD_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
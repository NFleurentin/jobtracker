create index jobtracker.ft_continents_ft_referential_load_id_i on
    jobtracker.ft_continents (
        ft_referential_load_id
    );


-- sqlcl_snapshot {"hash":"2514ce64dd874577d0ae830a898d2f8b5e8cdb9a","type":"INDEX","name":"FT_CONTINENTS_FT_REFERENTIAL_LOAD_ID_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>FT_CONTINENTS_FT_REFERENTIAL_LOAD_ID_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>FT_CONTINENTS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FT_REFERENTIAL_LOAD_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
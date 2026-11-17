create index jobtracker.ft_regions_ft_referential_load_id_i on
    jobtracker.ft_regions (
        ft_referential_load_id
    );


-- sqlcl_snapshot {"hash":"5a273dd56d0a2b952043314e9bbc56e8c3e10426","type":"INDEX","name":"FT_REGIONS_FT_REFERENTIAL_LOAD_ID_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>FT_REGIONS_FT_REFERENTIAL_LOAD_ID_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>FT_REGIONS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FT_REFERENTIAL_LOAD_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
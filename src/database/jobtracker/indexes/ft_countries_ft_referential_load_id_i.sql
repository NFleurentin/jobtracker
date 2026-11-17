create index jobtracker.ft_countries_ft_referential_load_id_i on
    jobtracker.ft_countries (
        ft_referential_load_id
    );


-- sqlcl_snapshot {"hash":"fe076a613335ab2c10aafeb7e4c5608fb477a094","type":"INDEX","name":"FT_COUNTRIES_FT_REFERENTIAL_LOAD_ID_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>FT_COUNTRIES_FT_REFERENTIAL_LOAD_ID_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>FT_COUNTRIES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FT_REFERENTIAL_LOAD_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
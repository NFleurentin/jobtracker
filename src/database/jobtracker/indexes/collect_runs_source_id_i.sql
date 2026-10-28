create index jobtracker.collect_runs_source_id_i on
    jobtracker.collect_runs (
        source_id
    );


-- sqlcl_snapshot {"hash":"3ed0445b557022078f21470623f2fb9d2222cbb3","type":"INDEX","name":"COLLECT_RUNS_SOURCE_ID_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>COLLECT_RUNS_SOURCE_ID_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>COLLECT_RUNS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>SOURCE_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
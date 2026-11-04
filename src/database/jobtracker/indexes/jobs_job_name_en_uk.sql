create unique index jobtracker.jobs_job_name_en_uk on
    jobtracker.jobs ( upper(job_name_en) );


-- sqlcl_snapshot {"hash":"6d99d5c0e6e195e7c4937f550a3f288d319feba2","type":"INDEX","name":"JOBS_JOB_NAME_EN_UK","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>JOBS_JOB_NAME_EN_UK</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>JOBS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <DEFAULT_EXPRESSION>UPPER(\"JOB_NAME_EN\")</DEFAULT_EXPRESSION>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
create unique index jobtracker.jobs_job_name_fr_uk on
    jobtracker.jobs ( upper(job_name_fr) );


-- sqlcl_snapshot {"hash":"3d23470d8e3cb948d7afef464f3a672190f3208a","type":"INDEX","name":"JOBS_JOB_NAME_FR_UK","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>JOBS_JOB_NAME_FR_UK</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>JOBS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <DEFAULT_EXPRESSION>UPPER(\"JOB_NAME_FR\")</DEFAULT_EXPRESSION>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
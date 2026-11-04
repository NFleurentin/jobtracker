create index jobtracker.contact_positions_job_id_i on
    jobtracker.contact_positions (
        job_id
    );


-- sqlcl_snapshot {"hash":"812e754265dc1c9a20a4783814ae160de5fb8e8f","type":"INDEX","name":"CONTACT_POSITIONS_JOB_ID_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>CONTACT_POSITIONS_JOB_ID_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>CONTACT_POSITIONS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>JOB_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
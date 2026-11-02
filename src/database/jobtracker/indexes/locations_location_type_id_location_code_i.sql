create index jobtracker.locations_location_type_id_location_code_i on
    jobtracker.locations (
        location_type_id,
        location_code
    );


-- sqlcl_snapshot {"hash":"3b1aa615e8963cfb41e2135ed5ab86f25ebb3821","type":"INDEX","name":"LOCATIONS_LOCATION_TYPE_ID_LOCATION_CODE_I","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>LOCATIONS_LOCATION_TYPE_ID_LOCATION_CODE_I</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>LOCATIONS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LOCATION_TYPE_ID</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOCATION_CODE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
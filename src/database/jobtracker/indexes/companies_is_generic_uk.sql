create unique index jobtracker.companies_is_generic_uk on
    jobtracker.companies (
        case
            when
                is_generic
            = true then
                1
        end
    );


-- sqlcl_snapshot {"hash":"b389b06ac686efda9baac69ad752f51af49e168b","type":"INDEX","name":"COMPANIES_IS_GENERIC_UK","schemaName":"JOBTRACKER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>COMPANIES_IS_GENERIC_UK</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>JOBTRACKER</SCHEMA>\n         <NAME>COMPANIES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <DEFAULT_EXPRESSION>CASE  WHEN \"IS_GENERIC\"=TRUE THEN 1 END </DEFAULT_EXPRESSION>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}
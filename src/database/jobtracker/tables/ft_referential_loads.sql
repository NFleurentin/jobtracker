create table jobtracker.ft_referential_loads (
    ft_referential_load_id number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20
    noorder nocycle nokeep noscale not null enable,
    started_at             timestamp(6) with time zone default systimestamp not null enable,
    ended_at               timestamp(6) with time zone,
    load_status            varchar2(10 char),
    load_details           json
);

alter table jobtracker.ft_referential_loads
    add constraint ft_referential_loads_dates_ck check ( ended_at >= started_at ) enable;

alter table jobtracker.ft_referential_loads
    add constraint ft_referential_loads_end_ck
        check ( ( ended_at is null
                  and load_status is null )
                or ( ended_at is not null
                     and load_status is not null ) ) enable;

alter table jobtracker.ft_referential_loads
    add constraint ft_referential_loads_load_status_ck
        check ( load_status in ( 'SUCCESS', 'PARTIAL', 'ERROR' ) ) enable;

alter table jobtracker.ft_referential_loads
    add constraint ft_referential_loads_pk primary key ( ft_referential_load_id )
        using index enable;


-- sqlcl_snapshot {"hash":"4fc0fedb74ac69d18e805c8d91ddb0e031e8f3b9","type":"TABLE","name":"FT_REFERENTIAL_LOADS","schemaName":"JOBTRACKER","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>FT_REFERENTIAL_LOADS</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FT_REFERENTIAL_LOAD_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <IDENTITY_COLUMN>\n               <SCHEMA>JOBTRACKER</SCHEMA>\n               <GENERATION>ALWAYS</GENERATION>\n               \n               <INCREMENT>1</INCREMENT>\n               <MINVALUE>1</MINVALUE>\n               <MAXVALUE>9999999999999999999999999999</MAXVALUE>\n               <CACHE>20</CACHE>\n               <SCALE>NOSCALE</SCALE>\n            </IDENTITY_COLUMN>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STARTED_AT</NAME>\n            <DATATYPE>TIMESTAMP_WITH_TIMEZONE</DATATYPE>\n            <SCALE>6</SCALE>\n            <DEFAULT>systimestamp</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ENDED_AT</NAME>\n            <DATATYPE>TIMESTAMP_WITH_TIMEZONE</DATATYPE>\n            <SCALE>6</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOAD_STATUS</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>10</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOAD_DETAILS</NAME>\n            <DATATYPE>JSON</DATATYPE>\n            \n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <CHECK_CONSTRAINT_LIST>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>FT_REFERENTIAL_LOADS_DATES_CK</NAME>\n            <CONDITION> ended_at >= started_at </CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>FT_REFERENTIAL_LOADS_LOAD_STATUS_CK</NAME>\n            <CONDITION> load_status in ( 'SUCCESS', 'PARTIAL', 'ERROR' ) </CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>FT_REFERENTIAL_LOADS_END_CK</NAME>\n            <CONDITION> ( ended_at is null and load_status is null )\n             or ( ended_at is not null and load_status is not null ) </CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n      </CHECK_CONSTRAINT_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>FT_REFERENTIAL_LOADS_PK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>FT_REFERENTIAL_LOAD_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n      \n   </RELATIONAL_TABLE>\n</TABLE>"}
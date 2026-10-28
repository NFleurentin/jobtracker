create table jobtracker.collect_runs (
    run_id               number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20
    noorder nocycle nokeep noscale not null enable,
    source_id            number not null enable,
    status               varchar2(10 char) default 'RUNNING' not null enable,
    started_at           timestamp(6) with time zone default systimestamp not null enable,
    ended_at             timestamp(6) with time zone,
    search_params        json,
    received_offer_count number(10, 0),
    error_message        varchar2(4000 char)
);

alter table jobtracker.collect_runs
    add constraint collect_runs_dates_ck check ( ended_at >= started_at ) enable;

alter table jobtracker.collect_runs
    add constraint collect_runs_end_ck
        check ( ( status = 'RUNNING'
                  and ended_at is null )
                or ( status <> 'RUNNING'
                     and ended_at is not null ) ) enable;

alter table jobtracker.collect_runs
    add constraint collect_runs_pk primary key ( run_id )
        using index enable;

alter table jobtracker.collect_runs
    add constraint collect_runs_status_ck
        check ( status in ( 'RUNNING', 'SUCCEEDED', 'FAILED', 'REJECTED' ) ) enable;


-- sqlcl_snapshot {"hash":"b5f46b2a0cd8df190e3a41cf09b91dc7bc6b1d53","type":"TABLE","name":"COLLECT_RUNS","schemaName":"JOBTRACKER","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>COLLECT_RUNS</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>RUN_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <IDENTITY_COLUMN>\n               <SCHEMA>JOBTRACKER</SCHEMA>\n               <GENERATION>ALWAYS</GENERATION>\n               \n               <INCREMENT>1</INCREMENT>\n               <MINVALUE>1</MINVALUE>\n               <MAXVALUE>9999999999999999999999999999</MAXVALUE>\n               <CACHE>20</CACHE>\n               <SCALE>NOSCALE</SCALE>\n            </IDENTITY_COLUMN>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SOURCE_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>10</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'RUNNING'</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STARTED_AT</NAME>\n            <DATATYPE>TIMESTAMP_WITH_TIMEZONE</DATATYPE>\n            <SCALE>6</SCALE>\n            <DEFAULT>systimestamp</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ENDED_AT</NAME>\n            <DATATYPE>TIMESTAMP_WITH_TIMEZONE</DATATYPE>\n            <SCALE>6</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SEARCH_PARAMS</NAME>\n            <DATATYPE>JSON</DATATYPE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RECEIVED_OFFER_COUNT</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>10</PRECISION>\n            <SCALE>0</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ERROR_MESSAGE</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>4000</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            \n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <CHECK_CONSTRAINT_LIST>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>COLLECT_RUNS_STATUS_CK</NAME>\n            <CONDITION>status in ('RUNNING', 'SUCCEEDED', 'FAILED', 'REJECTED')</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>COLLECT_RUNS_DATES_CK</NAME>\n            <CONDITION>ended_at >= started_at</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>COLLECT_RUNS_END_CK</NAME>\n            <CONDITION>   (status = 'RUNNING' and ended_at is null)\n             or (status &#60;> 'RUNNING' and ended_at is not null)</CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n      </CHECK_CONSTRAINT_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>COLLECT_RUNS_PK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>RUN_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n      \n   </RELATIONAL_TABLE>\n</TABLE>"}
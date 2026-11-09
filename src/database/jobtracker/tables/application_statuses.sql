create table jobtracker.application_statuses (
    application_status_id      number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache
    20 noorder nocycle nokeep noscale not null enable,
    application_status_code    varchar2(20 char) not null enable,
    application_status_name_fr varchar2(50 char) not null enable,
    application_status_name_en varchar2(50 char) not null enable,
    display_order              number(3, 0) not null enable,
    funnel_step                number(2, 0),
    is_final                   boolean not null enable
);

alter table jobtracker.application_statuses add constraint application_statuses_application_status_code_uk unique ( application_status_code
)
    using index enable;

alter table jobtracker.application_statuses add constraint application_statuses_application_status_name_en_uk unique ( application_status_name_en
)
    using index enable;

alter table jobtracker.application_statuses add constraint application_statuses_application_status_name_fr_uk unique ( application_status_name_fr
)
    using index enable;

alter table jobtracker.application_statuses add constraint application_statuses_display_order_uk unique ( display_order )
    using index enable;

alter table jobtracker.application_statuses add constraint application_statuses_funnel_step_ck check ( funnel_step > 0 ) enable;

alter table jobtracker.application_statuses add constraint application_statuses_funnel_step_uk unique ( funnel_step )
    using index enable;

alter table jobtracker.application_statuses
    add constraint application_statuses_pk primary key ( application_status_id )
        using index enable;


-- sqlcl_snapshot {"hash":"7f3db61df5c5a2d574f780c5f53f1dbb63cc68fd","type":"TABLE","name":"APPLICATION_STATUSES","schemaName":"JOBTRACKER","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>APPLICATION_STATUSES</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>APPLICATION_STATUS_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <IDENTITY_COLUMN>\n               <SCHEMA>JOBTRACKER</SCHEMA>\n               <GENERATION>ALWAYS</GENERATION>\n               \n               <INCREMENT>1</INCREMENT>\n               <MINVALUE>1</MINVALUE>\n               <MAXVALUE>9999999999999999999999999999</MAXVALUE>\n               <CACHE>20</CACHE>\n               <SCALE>NOSCALE</SCALE>\n            </IDENTITY_COLUMN>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APPLICATION_STATUS_CODE</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>20</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APPLICATION_STATUS_NAME_FR</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APPLICATION_STATUS_NAME_EN</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DISPLAY_ORDER</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>3</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FUNNEL_STEP</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>2</PRECISION>\n            <SCALE>0</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>IS_FINAL</NAME>\n            <DATATYPE>BOOLEAN</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <CHECK_CONSTRAINT_LIST>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>APPLICATION_STATUSES_FUNNEL_STEP_CK</NAME>\n            <CONDITION> funnel_step > 0 </CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n      </CHECK_CONSTRAINT_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>APPLICATION_STATUSES_PK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>APPLICATION_STATUS_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <UNIQUE_KEY_CONSTRAINT_LIST>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>APPLICATION_STATUSES_APPLICATION_STATUS_CODE_UK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>APPLICATION_STATUS_CODE</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>APPLICATION_STATUSES_APPLICATION_STATUS_NAME_FR_UK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>APPLICATION_STATUS_NAME_FR</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>APPLICATION_STATUSES_APPLICATION_STATUS_NAME_EN_UK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>APPLICATION_STATUS_NAME_EN</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>APPLICATION_STATUSES_DISPLAY_ORDER_UK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>DISPLAY_ORDER</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>APPLICATION_STATUSES_FUNNEL_STEP_UK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>FUNNEL_STEP</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n      </UNIQUE_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n      \n   </RELATIONAL_TABLE>\n</TABLE>"}
create table jobtracker.locations (
    location_id        number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20 noorder
    nocycle nokeep noscale not null enable,
    location_type_id   number not null enable,
    parent_location_id number,
    location_code      varchar2(10 char),
    location_name      varchar2(200 char) not null enable,
    longitude          number(9, 6),
    latitude           number(9, 6)
);

alter table jobtracker.locations
    add constraint locations_latitude_ck check ( latitude between - 90 and 90 ) enable;

alter table jobtracker.locations
    add constraint locations_longitude_ck check ( longitude between - 180 and 180 ) enable;

alter table jobtracker.locations
    add constraint locations_parent_location_id_ck check ( parent_location_id <> location_id ) enable;

alter table jobtracker.locations
    add constraint locations_parent_location_id_location_name_uk unique ( parent_location_id,
                                                                          location_name )
        using index enable;

alter table jobtracker.locations
    add constraint locations_pk primary key ( location_id )
        using index enable;


-- sqlcl_snapshot {"hash":"c4596536f973eb331349df2cc37745ce212a3b8c","type":"TABLE","name":"LOCATIONS","schemaName":"JOBTRACKER","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>JOBTRACKER</SCHEMA>\n   <NAME>LOCATIONS</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LOCATION_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <IDENTITY_COLUMN>\n               <SCHEMA>JOBTRACKER</SCHEMA>\n               <GENERATION>ALWAYS</GENERATION>\n               \n               <INCREMENT>1</INCREMENT>\n               <MINVALUE>1</MINVALUE>\n               <MAXVALUE>9999999999999999999999999999</MAXVALUE>\n               <CACHE>20</CACHE>\n               <SCALE>NOSCALE</SCALE>\n            </IDENTITY_COLUMN>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOCATION_TYPE_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PARENT_LOCATION_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOCATION_CODE</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>10</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LOCATION_NAME</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>200</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LONGITUDE</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>9</PRECISION>\n            <SCALE>6</SCALE>\n            \n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LATITUDE</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>9</PRECISION>\n            <SCALE>6</SCALE>\n            \n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <CHECK_CONSTRAINT_LIST>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>LOCATIONS_PARENT_LOCATION_ID_CK</NAME>\n            <CONDITION> parent_location_id &#60;> location_id </CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>LOCATIONS_LATITUDE_CK</NAME>\n            <CONDITION> latitude between -90 and 90 </CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n         <CHECK_CONSTRAINT_LIST_ITEM>\n            <NAME>LOCATIONS_LONGITUDE_CK</NAME>\n            <CONDITION> longitude between -180 and 180 </CONDITION>\n         </CHECK_CONSTRAINT_LIST_ITEM>\n      </CHECK_CONSTRAINT_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>LOCATIONS_PK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>LOCATION_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <UNIQUE_KEY_CONSTRAINT_LIST>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>LOCATIONS_PARENT_LOCATION_ID_LOCATION_NAME_UK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>PARENT_LOCATION_ID</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>LOCATION_NAME</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n      </UNIQUE_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n      \n   </RELATIONAL_TABLE>\n</TABLE>"}
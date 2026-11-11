-- liquibase formatted sql
-- changeset JOBTRACKER:1794409965016 stripComments:false  logicalFilePath:feat/work-modes/jobtracker/tables/work_modes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/work_modes.sql:null:108bc8e44a6079ebe41ace4de98135817f9c4ad2:create

create table jobtracker.work_modes (
    work_mode_id      number generated always as identity minvalue 1 maxvalue 9999999999999999999999999999 increment by 1 cache 20 noorder
    nocycle nokeep noscale not null enable,
    work_mode_code    varchar2(20 char) not null enable,
    work_mode_name_fr varchar2(50 char) not null enable,
    work_mode_name_en varchar2(50 char) not null enable
);

-- changeset JOBTRACKER:1794409965024 stripComments:false  logicalFilePath:feat/work-modes/jobtracker/tables/work_modes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/work_modes.sql:null:1c7bc4b7a393a6a850a86dfcf027f28da0c0d49e:create

alter table jobtracker.work_modes
    add constraint work_modes_pk primary key ( work_mode_id )
        using index enable;

-- changeset JOBTRACKER:1794409965031 stripComments:false  logicalFilePath:feat/work-modes/jobtracker/tables/work_modes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/work_modes.sql:null:9ca03fb0ed6a533efb154fae4cd78c067d3f7921:create

alter table jobtracker.work_modes add constraint work_modes_work_mode_code_uk unique ( work_mode_code )
    using index enable;

-- changeset JOBTRACKER:1794409965037 stripComments:false  logicalFilePath:feat/work-modes/jobtracker/tables/work_modes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/work_modes.sql:null:2063628e56765ec66da138196e2b27c4a2d31125:create

alter table jobtracker.work_modes add constraint work_modes_work_mode_name_en_uk unique ( work_mode_name_en )
    using index enable;

-- changeset JOBTRACKER:1794409965043 stripComments:false  logicalFilePath:feat/work-modes/jobtracker/tables/work_modes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/work_modes.sql:null:6d06456a36058c85379ce0e231d67b1f40367859:create

alter table jobtracker.work_modes add constraint work_modes_work_mode_name_fr_uk unique ( work_mode_name_fr )
    using index enable;


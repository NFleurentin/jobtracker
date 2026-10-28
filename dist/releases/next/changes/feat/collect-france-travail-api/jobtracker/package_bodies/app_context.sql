-- liquibase formatted sql
-- changeset JOBTRACKER:1793212579272 stripComments:false  logicalFilePath:feat/collect-france-travail-api/jobtracker/package_bodies/app_context.sql
-- sqlcl_snapshot src/database/jobtracker/package_bodies/app_context.sql:null:2da158185570b575155fefe37dc51e5db406a0ed:create

create or replace package body jobtracker.app_context is

    -- Workspace créé par l'amorçage (env/bootstrap/common/create_workspace.sql),
    -- même nom en dev et en prod
    co_workspace constant varchar2(30 char) := 'JOBTRACKER';

    procedure set_apex_workspace is
    begin
        apex_util.set_workspace(p_workspace => co_workspace);
    end set_apex_workspace;

end app_context;
/


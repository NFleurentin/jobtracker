-- liquibase formatted sql
-- changeset JOBTRACKER:1793212579390 stripComments:false  logicalFilePath:feat/collect-france-travail-api/jobtracker/package_specs/app_context.sql
-- sqlcl_snapshot src/database/jobtracker/package_specs/app_context.sql:null:cb9b537f38cb9c8e67d37482b5b111f9f914e894:create

create or replace package jobtracker.app_context authid definer is
    /**
     * Contexte d'exécution partagé par les points d'entrée lancés hors
     * session APEX (DBMS_SCHEDULER, SQLcl).
     */

    /**
     * Établit le workspace APEX de l'application, exigé hors session APEX par
     * les Web Credentials (APEX_WEB_SERVICE) et par APEX_MAIL.
     * Sans effet utile dans une session APEX, déjà rattachée au workspace.
     */
    procedure set_apex_workspace;

end app_context;
/


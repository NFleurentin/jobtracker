-- liquibase formatted sql
-- changeset JOBTRACKER:1794302514250 stripComments:false  logicalFilePath:feat/applications-read-views/jobtracker/views/ui_application_status_changes_list.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_application_status_changes_list.sql:null:7d78b10ba99cad253be841f3617e3fc30dfbe534:create

create or replace force editionable view jobtracker.ui_application_status_changes_list (
    application_status_change_id,
    application_id,
    application_status_id,
    application_status_name,
    is_final,
    changed_at,
    note_text,
    is_latest
) as
    select
        application_status_change_id,
        application_id,
        application_status_id,
        application_status_name,
        is_final,
        cast(changed_at as timestamp with local time zone) as changed_at,
        note_text,
        is_latest
    from
        jobtracker.application_status_change_details
with read only;


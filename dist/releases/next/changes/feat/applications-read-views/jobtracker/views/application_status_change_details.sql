-- liquibase formatted sql
-- changeset JOBTRACKER:1794302514224 stripComments:false  logicalFilePath:feat/applications-read-views/jobtracker/views/application_status_change_details.sql
-- sqlcl_snapshot src/database/jobtracker/views/application_status_change_details.sql:null:4af090c6c472efb80a088de63148ac657ab9bed1:create

create or replace force editionable view jobtracker.application_status_change_details (
    application_status_change_id,
    application_id,
    application_status_id,
    application_status_code,
    application_status_name,
    application_status_display_order,
    is_final,
    changed_at,
    note_text,
    is_latest
) as
    select
        sc.application_status_change_id,
        sc.application_id,
        sc.application_status_id,
        s.application_status_code,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                s.application_status_name_en
            else
                s.application_status_name_fr
        end             as application_status_name,
        s.display_order as application_status_display_order,
        s.is_final,
        sc.changed_at,
        sc.note_text,
        -- Dernier changement, seul corrigeable : même départage que le
        -- statut courant de application_details
        row_number()
        over(partition by sc.application_id
             order by
                 sc.changed_at desc, sc.application_status_change_id desc
        ) = 1 as is_latest
    from
             jobtracker.application_status_changes sc
        join jobtracker.application_statuses s on s.application_status_id = sc.application_status_id
with read only;


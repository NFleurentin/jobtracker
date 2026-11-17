-- liquibase formatted sql
-- changeset JOBTRACKER:1794953099553 stripComments:false  logicalFilePath:feat/apex-reload-ft-referentials/jobtracker/views/ui_ft_referential_loads_last.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_ft_referential_loads_last.sql:null:9d61d2b68abc8d27e68de3990ea6046e28adb459:create

create or replace force editionable view jobtracker.ui_ft_referential_loads_last (
    ft_referential_load_id,
    started_at,
    ended_at,
    load_state,
    load_state_label,
    error_count
) as
    select
        ft_referential_load_id,
        cast(started_at as timestamp with local time zone)                          as started_at,
        cast(ended_at as timestamp with local time zone)                            as ended_at,
        load_state,
        jobtracker.app_message.get_text('FT_REFERENTIAL_LOAD_STATE_' || load_state) as load_state_label,
        error_count
    from
        jobtracker.ft_referential_load_details
    where
        is_latest
with read only;


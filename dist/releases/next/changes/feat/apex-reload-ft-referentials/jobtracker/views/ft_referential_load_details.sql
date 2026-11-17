-- liquibase formatted sql
-- changeset JOBTRACKER:1794953099535 stripComments:false  logicalFilePath:feat/apex-reload-ft-referentials/jobtracker/views/ft_referential_load_details.sql
-- sqlcl_snapshot src/database/jobtracker/views/ft_referential_load_details.sql:null:a7c8458544b30c7ee58c01f65bcbe5ab2c1303e2:create

create or replace force editionable view jobtracker.ft_referential_load_details (
    ft_referential_load_id,
    started_at,
    ended_at,
    load_status,
    load_state,
    error_count,
    is_latest
) as
    select
        l.ft_referential_load_id,
        l.started_at,
        l.ended_at,
        l.load_status,
        case
            when l.load_status is not null then
                l.load_status
            when l.ft_referential_load_id = max(l.ft_referential_load_id)
                                                over()
                 and jobtracker.ft_referential_loader.is_load_running then
                'RUNNING'
            else
                'INTERRUPTED'
        end as load_state,
        (
            select
                count(*)
            from
                json_table ( l.load_details, '$.referentials[*]'
                    columns (
                        referential_status varchar2 ( 10 char ) path '$.status'
                    )
                )
            where
                referential_status = 'ERROR'
        )   as error_count,
        case
            when l.ft_referential_load_id = max(l.ft_referential_load_id)
                                            over() then
                true
            else
                false
        end as is_latest
    from
        jobtracker.ft_referential_loads l
with read only;


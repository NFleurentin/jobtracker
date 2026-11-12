-- liquibase formatted sql
-- changeset JOBTRACKER:1794510057485 stripComments:false  logicalFilePath:feat/browse-external-exchanges/jobtracker/views/external_exchange_name_values.sql
-- sqlcl_snapshot src/database/jobtracker/views/external_exchange_name_values.sql:null:a1f81c2aca22e1ed6f1ddb02757df790e412e008:create

create or replace force editionable view jobtracker.external_exchange_name_values (
    external_exchange_id,
    envelope,
    field_type,
    field_position,
    field_name,
    field_value
) as
    with http_exchanges as (
        select
            e.external_exchange_id,
            e.request,
            e.response
        from
                 jobtracker.external_exchanges e
            join jobtracker.exchange_protocols p on p.exchange_protocol_id = e.exchange_protocol_id
        where
            p.exchange_protocol_code = 'HTTP'
    )
    select
        h.external_exchange_id,
        'REQUEST' as envelope,
        'PARAM'   as field_type,
        j.field_position,
        j.field_name,
        j.field_value
    from
        http_exchanges h,
        json_table ( h.request, '$.params[*]'
                columns (
                    field_position for ordinality,
                    field_name varchar2 ( 4000 char ) truncate path '$.name',
                    field_value varchar2 ( 4000 char ) truncate path '$.value'
                )
            )
        j
    union all
    select
        h.external_exchange_id,
        'REQUEST' as envelope,
        'HEADER'  as field_type,
        j.field_position,
        j.field_name,
        j.field_value
    from
        http_exchanges h,
        json_table ( h.request, '$.headers[*]'
                columns (
                    field_position for ordinality,
                    field_name varchar2 ( 4000 char ) truncate path '$.name',
                    field_value varchar2 ( 4000 char ) truncate path '$.value'
                )
            )
        j
    union all
    select
        h.external_exchange_id,
        'RESPONSE' as envelope,
        'HEADER'   as field_type,
        j.field_position,
        j.field_name,
        j.field_value
    from
        http_exchanges h,
        json_table ( h.response, '$.headers[*]'
                columns (
                    field_position for ordinality,
                    field_name varchar2 ( 4000 char ) truncate path '$.name',
                    field_value varchar2 ( 4000 char ) truncate path '$.value'
                )
            )
        j
with read only;


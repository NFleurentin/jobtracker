-- liquibase formatted sql
-- changeset JOBTRACKER:1794510057500 stripComments:false  logicalFilePath:feat/browse-external-exchanges/jobtracker/views/ui_exchange_request_headers_list.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_exchange_request_headers_list.sql:null:c432d355c4d191c278b524e89f417bf79ad7c7a1:create

create or replace force editionable view jobtracker.ui_exchange_request_headers_list (
    external_exchange_id,
    field_position,
    field_name,
    field_value
) as
    select
        external_exchange_id,
        field_position,
        field_name,
        field_value
    from
        jobtracker.external_exchange_name_values
    where
            envelope = 'REQUEST'
        and field_type = 'HEADER'
with read only;


-- liquibase formatted sql
-- changeset JOBTRACKER:1794510057490 stripComments:false  logicalFilePath:feat/browse-external-exchanges/jobtracker/views/ui_exchange_request_params_list.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_exchange_request_params_list.sql:null:d6a6f42b14640c3823bd9f323efd4d22718800e6:create

create or replace force editionable view jobtracker.ui_exchange_request_params_list (
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
        and field_type = 'PARAM'
with read only;


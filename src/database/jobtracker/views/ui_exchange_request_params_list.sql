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


-- sqlcl_snapshot {"hash":"d6a6f42b14640c3823bd9f323efd4d22718800e6","type":"VIEW","name":"UI_EXCHANGE_REQUEST_PARAMS_LIST","schemaName":"JOBTRACKER","sxml":""}
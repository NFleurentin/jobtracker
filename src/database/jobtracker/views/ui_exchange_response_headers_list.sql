create or replace force editionable view jobtracker.ui_exchange_response_headers_list (
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
            envelope = 'RESPONSE'
        and field_type = 'HEADER'
with read only;


-- sqlcl_snapshot {"hash":"feca612d84f902f8e41c732bbfe84eb5d8555b61","type":"VIEW","name":"UI_EXCHANGE_RESPONSE_HEADERS_LIST","schemaName":"JOBTRACKER","sxml":""}
create or replace force editionable view jobtracker.ui_external_exchanges_list (
    external_exchange_id,
    exchange_label,
    external_system_id,
    external_system_name,
    exchange_protocol_id,
    exchange_protocol_name,
    exchange_status_id,
    exchange_status_name,
    correlation_id,
    request_method,
    request_url,
    response_status_code,
    error_summary,
    started_at,
    ended_at,
    duration_seconds
) as
    select
        external_exchange_id,
        -- Libellé qui nomme la ligne (Value Identifies Row) : système et heure
        -- de début dans le fuseau de la session (celui du navigateur en APEX)
        external_system_name
        || ' '
        || to_char(cast(started_at as timestamp with local time zone), 'DD/MM/YYYY HH24:MI:SS') as exchange_label,
        external_system_id,
        external_system_name,
        exchange_protocol_id,
        exchange_protocol_name,
        exchange_status_id,
        exchange_status_name,
        -- En hexadécimal pour un item de page
        rawtohex(correlation_id)                                                                as correlation_id,
        request_method,
        request_url,
        response_status_code,
        case
            when length(error_message) > 200 then
                substr(error_message, 1, 199)
                || '…'
            else
                error_message
        end                                                                                     as error_summary,
        cast(started_at as timestamp with local time zone)                                      as started_at,
        cast(ended_at as timestamp with local time zone)                                        as ended_at,
        duration_seconds
    from
        jobtracker.external_exchange_details
with read only;


-- sqlcl_snapshot {"hash":"c43cc1a0b02d100cc78c270da83ec9d3b16582d1","type":"VIEW","name":"UI_EXTERNAL_EXCHANGES_LIST","schemaName":"JOBTRACKER","sxml":""}
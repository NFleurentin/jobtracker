create or replace force editionable view jobtracker.ui_external_exchanges_detail (
    external_exchange_id,
    external_system_name,
    exchange_protocol_code,
    exchange_protocol_name,
    exchange_status_name,
    correlation_id,
    request_method,
    request_url,
    response_status_code,
    request_body,
    response_body,
    request_text,
    response_text,
    error_message,
    started_at,
    ended_at,
    duration_seconds,
    app_user,
    apex_session_id,
    db_module,
    db_action,
    db_sid
) as
    select
        external_exchange_id,
        external_system_name,
        -- Code stable : condition d'affichage des régions propres au protocole
        exchange_protocol_code,
        exchange_protocol_name,
        exchange_status_name,
        rawtohex(correlation_id)                           as correlation_id,
        request_method,
        request_url,
        response_status_code,
        -- Corps et enveloppes, à afficher échappés ; enveloppes indentées,
        -- pour un protocole sans région dédiée
        request_body,
        response_body,
        json_serialize(request returning clob pretty)      as request_text,
        json_serialize(response returning clob pretty)     as response_text,
        error_message,
        cast(started_at as timestamp with local time zone) as started_at,
        cast(ended_at as timestamp with local time zone)   as ended_at,
        duration_seconds,
        app_user,
        apex_session_id,
        db_module,
        db_action,
        db_sid
    from
        jobtracker.external_exchange_details
with read only;


-- sqlcl_snapshot {"hash":"803d0a0a709283a51def72094dbd4e236d938049","type":"VIEW","name":"UI_EXTERNAL_EXCHANGES_DETAIL","schemaName":"JOBTRACKER","sxml":""}
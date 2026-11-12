-- liquibase formatted sql
-- changeset JOBTRACKER:1794510057459 stripComments:false  logicalFilePath:feat/browse-external-exchanges/jobtracker/views/external_exchange_details.sql
-- sqlcl_snapshot src/database/jobtracker/views/external_exchange_details.sql:null:de76f519f7d2360acb06874c92a2dcd29922ceab:create

create or replace force editionable view jobtracker.external_exchange_details (
    external_exchange_id,
    external_system_id,
    external_system_code,
    external_system_name,
    exchange_protocol_id,
    exchange_protocol_code,
    exchange_protocol_name,
    exchange_status_id,
    exchange_status_code,
    exchange_status_name,
    correlation_id,
    request_method,
    request_url,
    response_status_code,
    request_body,
    response_body,
    request,
    response,
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
        e.external_exchange_id,
        e.external_system_id,
        sy.external_system_code,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                sy.external_system_name_en
            else
                sy.external_system_name_fr
        end                                                                                                                                       as
        external_system_name,
        e.exchange_protocol_id,
        p.exchange_protocol_code,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                p.exchange_protocol_name_en
            else
                p.exchange_protocol_name_fr
        end                                                                                                                                       as
        exchange_protocol_name,
        e.exchange_status_id,
        st.exchange_status_code,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                st.exchange_status_name_en
            else
                st.exchange_status_name_fr
        end                                                                                                                                       as
        exchange_status_name,
        e.correlation_id,
        -- Champs lus dans les enveloppes selon le protocole : null pour un
        -- protocole qui ne les porte pas, ou pour une enveloppe mal formée
        -- (NULL ON ERROR, comportement par défaut de JSON_VALUE)
        case p.exchange_protocol_code
            when 'HTTP' then
                json_value(e.request, '$.method' returning varchar2(10 char))
        end                                                                                                                                       as
        request_method,
        case p.exchange_protocol_code
            when 'HTTP' then
                json_value(e.request, '$.url' returning varchar2(4000 char))
        end                                                                                                                                       as
        request_url,
        case p.exchange_protocol_code
            when 'HTTP' then
                json_value(e.response, '$.status_code' returning number)
        end                                                                                                                                       as
        response_status_code,
        -- Corps : imbriqué s'il est du JSON (indenté pour la lecture), chaîne
        -- sinon (page d'erreur HTML...), null s'il est absent ou JSON null
        case p.exchange_protocol_code
            when 'HTTP' then
                    case json_value(e.request, '$.body.type()')
                        when 'string' then
                            json_value(e.request, '$.body' returning clob)
                        when 'object' then
                            json_query(e.request, '$.body' returning clob pretty)
                        when 'array'  then
                            json_query(e.request, '$.body' returning clob pretty)
                    end
        end                                                                                                                                       as
        request_body,
        case p.exchange_protocol_code
            when 'HTTP' then
                    case json_value(e.response, '$.body.type()')
                        when 'string' then
                            json_value(e.response, '$.body' returning clob)
                        when 'object' then
                            json_query(e.response, '$.body' returning clob pretty)
                        when 'array'  then
                            json_query(e.response, '$.body' returning clob pretty)
                    end
        end                                                                                                                                       as
        response_body,
        e.request,
        e.response,
        e.error_message,
        e.started_at,
        e.ended_at,
        -- Durée en secondes (millisecondes en décimales), null tant que
        -- l'échange est en cours
        extract(day from(e.ended_at - e.started_at)) * 86400 + extract(hour from(e.ended_at - e.started_at)) * 3600 + extract(minute from
        (e.ended_at - e.started_at)) * 60 + extract(second from(e.ended_at - e.started_at)) as duration_seconds,
        e.app_user,
        e.apex_session_id,
        e.db_module,
        e.db_action,
        e.db_sid
    from
             jobtracker.external_exchanges e
        join jobtracker.external_systems   sy on sy.external_system_id = e.external_system_id
        join jobtracker.exchange_protocols p on p.exchange_protocol_id = e.exchange_protocol_id
        join jobtracker.exchange_statuses  st on st.exchange_status_id = e.exchange_status_id
with read only;


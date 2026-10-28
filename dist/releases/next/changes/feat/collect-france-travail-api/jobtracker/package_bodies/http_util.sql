-- liquibase formatted sql
-- changeset JOBTRACKER:1793212579297 stripComments:false  logicalFilePath:feat/collect-france-travail-api/jobtracker/package_bodies/http_util.sql
-- sqlcl_snapshot src/database/jobtracker/package_bodies/http_util.sql:null:3d8ce82499bac08d3348a250c596c26b48f2bdb7:create

create or replace package body jobtracker.http_util is

    co_scope_prefix constant varchar2(31 char) := lower($$plsql_unit)
                                                  || '.';

    function make_rest_request (
        in_url                  in varchar2,
        in_http_method          in varchar2,
        in_credential_static_id in varchar2 default null,
        in_token_url            in varchar2 default null
    ) return clob is
        pragma autonomous_transaction;
        l_scope logger_logs.scope%type := co_scope_prefix || 'make_rest_request';
        l_body  clob;
    begin
        l_body := apex_web_service.make_rest_request(
            p_url                  => in_url,
            p_http_method          => in_http_method,
            p_credential_static_id => in_credential_static_id,
            p_token_url            => in_token_url
        );
        -- Termine la transaction autonome (sinon ORA-06519) en gardant ce
        -- qu'APEX a pu écrire, comme le jeton ; sans effet sur l'appelant
        commit;
        return l_body;
    exception
        when others then
            logger.log_error('HTTP call failed: ' || in_url, l_scope);
            -- Sans ROLLBACK, ORA-06519 masquerait l'erreur d'origine
            rollback;
            raise;
    end make_rest_request;

    function is_server_error (
        in_status_code in pls_integer
    ) return boolean is
    begin
        return coalesce(in_status_code between 500 and 599, false);
    end is_server_error;

    function is_retryable (
        in_status_code in pls_integer
    ) return boolean is
    begin
        return coalesce(in_status_code = co_status_too_many_requests
        or is_server_error(in_status_code),
                        false);
    end is_retryable;

    function retry_delay (
        in_attempt     in pls_integer,
        in_retry_after in varchar2
    ) return number is
    begin
        -- Retry-After peut aussi être une date HTTP : seul un nombre de secondes est lu
        if regexp_like(
            trim(in_retry_after),
            '^\d+$'
        ) then
            return least(to_number(trim(in_retry_after)),
                         co_max_retry_delay);
        end if;

        return least(
            power(2, in_attempt),
            co_max_retry_delay
        );
    end retry_delay;

    function response_header (
        in_name in varchar2
    ) return varchar2 is
    begin
        << headers >> for i in 1..apex_web_service.g_headers.count loop
            if lower(apex_web_service.g_headers(i).name) = lower(in_name) then
                return apex_web_service.g_headers(i).value;
            end if;
        end loop headers;

        return null;
    end response_header;

    function response_headers return json is
        l_headers json_object_t := json_object_t();
    begin
        << headers >> for i in 1..apex_web_service.g_headers.count loop
            l_headers.put(apex_web_service.g_headers(i).name,
                          apex_web_service.g_headers(i).value);
        end loop headers;

        return l_headers.to_json;
    end response_headers;

end http_util;
/


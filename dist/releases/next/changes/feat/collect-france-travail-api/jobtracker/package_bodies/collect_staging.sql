-- liquibase formatted sql
-- changeset JOBTRACKER:1793212579267 stripComments:false  logicalFilePath:feat/collect-france-travail-api/jobtracker/package_bodies/collect_staging.sql
-- sqlcl_snapshot src/database/jobtracker/package_bodies/collect_staging.sql:null:b0e3d231eaaf5e1c788ff226182fa9c0dd6423b4:create

create or replace package body jobtracker.collect_staging is

    -- Taille maximale d'error_message, en octets : sûre que la base soit en
    -- MAX_STRING_SIZE STANDARD (dev) ou EXTENDED (ADB)
    co_error_max_bytes constant pls_integer := 4000;

    function open_run (
        in_source_code   in offer_sources.source_code%type,
        in_search_params in json
    ) return collect_runs.run_id%type is
        l_source_id offer_sources.source_id%type;
        l_run_id    collect_runs.run_id%type;
    begin
        begin
            select
                source_id
            into l_source_id
            from
                offer_sources
            where
                source_code = in_source_code;

        exception
            when no_data_found then
                raise_application_error(app_errors.co_not_found, 'Unknown offer source: ' || in_source_code);
        end;

        insert into collect_runs (
            source_id,
            search_params
        ) values
            ( l_source_id,
              in_search_params )
        returning run_id into l_run_id;

        return l_run_id;
    end open_run;

    procedure close_run (
        in_run_id               in collect_runs.run_id%type,
        in_status               in collect_runs.status%type,
        in_received_offer_count in collect_runs.received_offer_count%type default null,
        in_error_message        in collect_runs.error_message%type default null
    ) is
    begin
        update collect_runs
        set
            status = in_status,
            ended_at = systimestamp,
            received_offer_count = in_received_offer_count,
            error_message = in_error_message
        where
                run_id = in_run_id
            and status = co_status_running;

        if sql%rowcount = 0 then
            raise_application_error(app_errors.co_invalid_state, 'Run '
                                                                 || in_run_id
                                                                 || ' does not exist or is not running');
        end if;

    end close_run;

    function open_request (
        in_run_id         in collect_runs.run_id%type,
        in_http_method    in collect_requests.http_method%type,
        in_request_url    in collect_requests.request_url%type,
        in_request_params in json
    ) return collect_requests.request_id%type is
        l_request_seq collect_requests.request_seq%type;
        l_request_id  collect_requests.request_id%type;
    begin
        -- Un seul processus par run : pas de concurrence sur le numéro
        select
            nvl(
                max(request_seq),
                0
            ) + 1
        into l_request_seq
        from
            collect_requests
        where
            run_id = in_run_id;

        insert into collect_requests (
            run_id,
            request_seq,
            http_method,
            request_url,
            request_params,
            started_at
        ) values
            ( in_run_id,
              l_request_seq,
              in_http_method,
              in_request_url,
              in_request_params,
              systimestamp )
        returning request_id into l_request_id;

        return l_request_id;
    end open_request;

    procedure close_request (
        in_request_id       in collect_requests.request_id%type,
        in_response_code    in collect_requests.response_code%type,
        in_response_headers in json,
        in_response_body    in clob,
        in_error_message    in varchar2 default null
    ) is
        l_is_json       boolean := in_response_body is json;
        l_error_message varchar2(32767 char) := in_error_message;
    begin
        if
            not l_is_json
            and dbms_lob.getlength(in_response_body) > 0
        then
            l_error_message := l_error_message
                               ||
                case
                    when l_error_message is not null then
                        chr(10)
                end
                               || dbms_lob.substr(in_response_body, co_error_max_bytes, 1);
        end if;

        update collect_requests
        set
            ended_at = systimestamp,
            response_code = in_response_code,
            response_headers = in_response_headers,
            response_payload_json =
                case
                    when l_is_json then
                            json(
                                in_response_body
                            )
                end,
            error_message = substrb(l_error_message, 1, co_error_max_bytes)
        where
            request_id = in_request_id;

        if sql%rowcount = 0 then
            raise_application_error(app_errors.co_not_found, 'Request '
                                                             || in_request_id
                                                             || ' does not exist');
        end if;

    end close_request;

end collect_staging;
/


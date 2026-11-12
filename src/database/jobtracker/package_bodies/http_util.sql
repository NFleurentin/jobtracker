create or replace package body jobtracker.http_util is

    co_scope_prefix constant varchar2(31 char) := lower($$plsql_unit)
                                                  || '.';

    /**
     * Paires nom-valeur d'un objet JSON {"nom": valeur}, dans l'ordre des
     * clés ; une valeur tableau donne une paire par élément, une valeur null
     * est ignorée. Forme commune aux paramètres et aux en-têtes de requête.
     * @return collection vide si in_object est null
     */
    function name_values (
        in_object in json
    ) return apex_web_service.header_table is
        l_object json_object_t;
        l_keys   json_key_list;
        l_values json_array_t;
        l_pairs  apex_web_service.header_table;
    begin
        if in_object is null then
            return l_pairs;
        end if;
        l_object := json_object_t(in_object);
        l_keys := l_object.get_keys;
        << keys >> for i in 1..l_keys.count loop
            -- Valeur simple traitée comme un tableau d'un élément
            if l_object.get(l_keys(i)).is_array then
                l_values := l_object.get_array(l_keys(i));
            else
                l_values := json_array_t();
                l_values.append(l_object.get(l_keys(i)));
            end if;

            << key_values >> for j in 0..l_values.get_size - 1 loop
                if not l_values.get(j).is_null then
                    l_pairs(l_pairs.count + 1).name := l_keys(i);
                    l_pairs(l_pairs.count).value := l_values.get_string(j);
                end if;
            end loop key_values;

        end loop keys;

        return l_pairs;
    end name_values;

    function build_url (
        in_url    in varchar2,
        in_params in json
    ) return varchar2 is

        l_params    apex_web_service.header_table := name_values(in_params);
        l_url       varchar2(32767 char) := in_url;
        -- Premier séparateur : ? sans query string, chr(38) sinon
        l_separator varchar2(1 char) :=
            case
                when instr(in_url, '?') = 0 then
                    '?'
                else
                    chr(38)
            end;
    begin
        << params >> for i in 1..l_params.count loop
            l_url := l_url
                     || l_separator
                     || utl_url.escape(l_params(i).name,
                                       true,
                                       'AL32UTF8')
                     || '='
                     || utl_url.escape(l_params(i).value,
                                       true,
                                       'AL32UTF8');

            l_separator := chr(38);
        end loop params;

        return l_url;
    end build_url;

    /**
     * Paires nom-valeur (paramètres ou en-têtes) en tableau JSON
     * [{"name", "value"}], ordre et répétitions conservés. La valeur d'un nom
     * sensible (Authorization, Cookie...) est masquée, quel que soit le type
     * de paire : un paramètre ne devrait de toute façon pas porter de secret.
     */
    function pairs_to_json (
        in_pairs in apex_web_service.header_table
    ) return json_array_t is
        l_pairs json_array_t := json_array_t();
        l_pair  json_object_t;
    begin
        << pairs >> for i in 1..in_pairs.count loop
            l_pair := json_object_t();
            l_pair.put('name',
                       in_pairs(i).name);
            l_pair.put('value',
                       case
                           when lower(in_pairs(i).name) in('authorization', 'proxy-authorization', 'cookie', 'set-cookie') then
                               '***'
                           else
                               in_pairs(i).value
                       end
            );

            l_pairs.append(l_pair);
        end loop pairs;

        return l_pairs;
    end pairs_to_json;

    /**
     * Ajoute le corps à une enveloppe : imbriqué s'il est du JSON, en chaîne
     * sinon (page d'erreur HTML, texte), null s'il est vide.
     */
    procedure put_body (
        io_envelope in out nocopy json_object_t,
        in_body     in clob
    ) is
        l_is_json pls_integer;
    begin
        if dbms_lob.getlength(in_body) > 0 then
            select
                count(*)
            into l_is_json
            from
                dual
            where
                in_body is json;

            if l_is_json = 1 then
                io_envelope.put('body',
                                json_element_t.parse(in_body));
            else
                io_envelope.put('body', in_body);
            end if;

        else
            io_envelope.put_null('body');
        end if;
    end put_body;

    function make_rest_request (
        in_url                  in varchar2,
        in_http_method          in varchar2,
        in_external_system_code in varchar2,
        in_params               in json default null,
        in_headers              in json default null,
        in_credential_static_id in varchar2 default null,
        in_token_url            in varchar2 default null,
        in_correlation_id       in raw default null,
        in_transfer_timeout     in pls_integer default co_transfer_timeout
    ) return clob is

        pragma autonomous_transaction;
        l_scope       logger_logs.scope%type := co_scope_prefix || 'make_rest_request';
        l_url         varchar2(32767 char);
        l_request     json_object_t := json_object_t();
        l_response    json_object_t := json_object_t();
        l_exchange_id external_exchanges.external_exchange_id%type;
        l_body        clob;
    begin
        l_url := build_url(in_url, in_params);
        -- En-têtes de cet appel seulement : la variable de package d'APEX
        -- survit d'un appel à l'autre dans la session
        apex_web_service.g_request_headers := name_values(in_headers);
        -- Enveloppe HTTP du journal : ce qui est réellement envoyé
        l_request.put('url', l_url);
        l_request.put('method', in_http_method);
        l_request.put('params',
                      pairs_to_json(name_values(in_params)));
        l_request.put('headers',
                      pairs_to_json(apex_web_service.g_request_headers));
        -- Aucun corps de requête : les appels sont des GET
        l_request.put_null('body');
        -- Validé en transaction autonome propre : le ROLLBACK que fait APEX en
        -- obtenant un jeton OAuth2 ne l'efface pas
        l_exchange_id := exchange_log.open_exchange(
            in_external_system_code   => in_external_system_code,
            in_exchange_protocol_code => exchange_log.co_protocol_http,
            in_request                => l_request.to_json,
            in_correlation_id         => in_correlation_id
        );

        l_body := apex_web_service.make_rest_request(
            p_url                  => l_url,
            p_http_method          => in_http_method,
            p_credential_static_id => in_credential_static_id,
            p_token_url            => in_token_url,
            p_transfer_timeout     => in_transfer_timeout
        );

        apex_web_service.g_request_headers.delete;
        l_response.put('status_code', apex_web_service.g_status_code);
        l_response.put('headers',
                       pairs_to_json(apex_web_service.g_headers));
        put_body(l_response, l_body);
        exchange_log.complete_exchange(l_exchange_id, l_response.to_json);
        -- Termine la transaction autonome (sinon ORA-06519) en gardant ce
        -- qu'APEX a pu écrire, comme le jeton ; sans effet sur l'appelant
        commit;
        return l_body;
    exception
        when others then
            apex_web_service.g_request_headers.delete;
            logger.log_error('HTTP call failed: ' || coalesce(l_url, in_url),
                             l_scope);
            -- Sans ROLLBACK, ORA-06519 masquerait l'erreur d'origine
            rollback;
            -- Échange ouvert : trace de l'échec, dans sa propre transaction
            -- autonome. S'il échoue à son tour, son erreur remplace celle
            -- d'origine, déjà journalisée ci-dessus
            if l_exchange_id is not null then
                exchange_log.fail_exchange(l_exchange_id, sqlerrm);
            end if;
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


-- sqlcl_snapshot {"hash":"d00dce3aa9d01d56ea3669ba6fed5be5c82fad0a","type":"PACKAGE_BODY","name":"HTTP_UTIL","schemaName":"JOBTRACKER","sxml":""}
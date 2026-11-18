-- liquibase formatted sql
-- changeset JOBTRACKER:1794997765665 stripComments:false  logicalFilePath:feat/collect-offer-search/jobtracker/package_bodies/france_travail_api.sql
-- sqlcl_snapshot src/database/jobtracker/package_bodies/france_travail_api.sql:cd9d3e876161dd8aa140fa32ab4717f3c7b10525:4b1aa98ad337e8cf9e61e59cfe2df2a80d9bf437:alter

create or replace package body jobtracker.france_travail_api is

    co_scope_prefix         constant varchar2(31 char) := lower($$plsql_unit)
                                                  || '.';
    co_base_url             constant varchar2(100 char) := 'https://api.francetravail.io/partenaire';
    co_credential_static_id constant varchar2(30 char) := 'FRANCE_TRAVAIL_API';
    co_token_url            constant varchar2(200 char) := 'https://entreprise.francetravail.fr/connexion/oauth2/access_token?realm=/partenaire'
    ;

    -- Motif de la dernière réponse en erreur, voir last_error_message
    g_last_error_message    varchar2(4000 char);

    /**
     * Champ "message" d'un corps de réponse en erreur.
     * @return null si le corps n'est pas du JSON ou n'a pas ce champ
     */
    function error_message (
        in_body in clob
    ) return varchar2 is
        l_message varchar2(4000 char);
    begin
        -- null on error : un corps HTML ou vide (passerelle, 5xx) ne doit pas
        -- masquer l'erreur HTTP que l'appelant va lever
        select
            json_value(in_body, '$.message' returning varchar2(4000 char) truncate null on error)
        into l_message
        from
            dual;

        return l_message;
    end error_message;

    function last_error_message return varchar2 is
    begin
        return g_last_error_message;
    end last_error_message;

    function endpoint_url (
        in_endpoint in varchar2
    ) return varchar2 is
    begin
        return co_base_url || in_endpoint;
    end endpoint_url;

    function call (
        in_endpoint       in varchar2,
        in_params         in json default null,
        in_correlation_id in raw default null,
        in_max_attempts   in pls_integer default co_max_attempts
    ) return clob is

        l_scope        logger_logs.scope%type := co_scope_prefix || 'call';
        l_url          varchar2(32767 char) := endpoint_url(in_endpoint);
        -- Au moins un essai, même si in_max_attempts est null ou inférieur à 1
        l_max_attempts pls_integer := greatest(
            coalesce(in_max_attempts, 1),
            1
        );
        l_body         clob;
        l_status_code  pls_integer;
    begin
        g_last_error_message := null;
        << attempts >> for l_attempt in 1..l_max_attempts loop
            -- Erreur sans réponse déjà journalisée et tracée par http_util
            l_body := http_util.make_rest_request(
                in_url                  => l_url,
                in_http_method          => http_util.co_method_get,
                in_external_system_code => exchange_log.co_system_france_travail,
                in_params               => in_params,
                in_credential_static_id => co_credential_static_id,
                in_token_url            => co_token_url,
                in_correlation_id       => in_correlation_id
            );

            l_status_code := apex_web_service.g_status_code;
            if http_util.is_success(l_status_code) then
                return l_body;
            end if;
            exit attempts when not http_util.is_retryable(l_status_code)
            or l_attempt = l_max_attempts;
            logger.log_warning('HTTP '
                               || l_status_code
                               || ', attempt '
                               || l_attempt
                               || ': '
                               || http_util.build_url(l_url, in_params),
                               l_scope);

            dbms_session.sleep(http_util.retry_delay(l_attempt,
                                                     http_util.response_header(http_util.co_header_retry_after)));

        end loop attempts;

        g_last_error_message := error_message(l_body);
        raise_application_error(app_errors.co_http_error,
                                'HTTP '
                                || l_status_code
                                || ' on '
                                || http_util.build_url(l_url, in_params));

    end call;

end france_travail_api;
/


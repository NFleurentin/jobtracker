-- liquibase formatted sql
-- changeset JOBTRACKER:1793212579386 stripComments:false  logicalFilePath:feat/collect-france-travail-api/jobtracker/package_bodies/collect_france_travail.sql
-- sqlcl_snapshot src/database/jobtracker/package_bodies/collect_france_travail.sql:null:904dbe5b17316085be907749c2a76caf0c3dd242:create

create or replace package body jobtracker.collect_france_travail is

    co_scope_prefix         constant varchar2(31 char) := lower($$plsql_unit)
                                                  || '.';
    co_source_code          constant offer_sources.source_code%type := 'FRANCE_TRAVAIL';
    co_credential_static_id constant varchar2(30 char) := 'FRANCE_TRAVAIL_API';
    co_token_url            constant varchar2(200 char) := 'https://entreprise.francetravail.fr/connexion/oauth2/access_token?realm=/partenaire'
    ;
    co_search_url           constant varchar2(200 char) := 'https://api.francetravail.io/partenaire/offresdemploi/v2/offres/search';
    -- Séparateur de paramètres d'URL, écrit chr(38) : SQL*Plus et SQLcl prennent
    -- une esperluette littérale pour une variable de substitution (DEFINE)
    co_ampersand            constant varchar2(1 char) := chr(38);

    -- Recherches, une par mot-clé : dans motsCles, la virgule est un ET.
    -- Provisoire, en dur (reprises de jobboard) : à rendre paramétrables.
    co_searches             constant sys.odcivarchar2list := sys.odcivarchar2list('sql', 'analytics engineer', 'plsql', 'pl-sql', 'pl/sql'
    ,
                                                                      'pl sql', 'snowflake', 'dbt', 'développeur oracle');

    -- -------------------------------------------------------------------------
    -- Fonctions pures
    -- -------------------------------------------------------------------------
    function parse_total (
        in_content_range in varchar2
    ) return pls_integer is
    begin
        return to_number ( regexp_substr(in_content_range, '/(\d+)$', 1, 1, null,
                                         1) );
    end parse_total;

    function has_more (
        in_status_code in pls_integer,
        in_offset      in pls_integer,
        in_total       in pls_integer
    ) return boolean is
    begin
        -- 200 : tout le résultat tient dans la page ; 204 : aucun résultat
        if in_status_code is null
           or in_status_code != utl_http.http_partial_content then
            return false;
        end if;
        if
            in_total is not null
            and in_offset + co_page_size >= in_total
        then
            return false;
        end if;

        -- La page commençant à co_max_offset est la dernière autorisée
        return in_offset < co_max_offset;
    end has_more;

    procedure check_page (
        in_status_code in pls_integer,
        in_total       in pls_integer
    ) is
    begin
        -- Seules les 206 sont contrôlées : une 200 ou une 204 tient en une page
        if in_status_code = utl_http.http_partial_content then
            if in_total is null then
                raise_application_error(app_errors.co_invalid_response, 'Missing or unreadable Content-Range header');
            elsif in_total > co_max_results then
                raise_application_error(app_errors.co_limit_exceeded, 'Search returns '
                                                                      || in_total
                                                                      || ' results, above the API cap of '
                                                                      || co_max_results
                                                                      || ': narrow it down');
            end if;

        end if;
    end check_page;

    -- -------------------------------------------------------------------------
    -- Appels HTTP
    -- -------------------------------------------------------------------------

    /**
     * Demande une page de résultats, avec de nouveaux essais sur 429 et 5xx.
     * Chaque essai est tracé par sa propre ligne collect_requests.
     * @param in_offset       index de début de la page demandée
     * @param out_total       total de la recherche, null sans Content-Range
     * @param out_offer_count nombre d'offres de la page, 0 sur une 204
     * @throws app_errors.co_http_error code HTTP en échec, ou essais épuisés
     */
    procedure fetch_page (
        in_run_id       in collect_runs.run_id%type,
        in_keywords     in varchar2,
        in_offset       in pls_integer,
        out_status_code out pls_integer,
        out_total       out pls_integer,
        out_offer_count out pls_integer
    ) is

        l_scope      logger_logs.scope%type := co_scope_prefix || 'fetch_page';
        l_range      varchar2(20 char) := in_offset
                                     || '-'
                                     || ( in_offset + co_page_size - 1 );
        l_url        collect_requests.request_url%type := co_search_url
                                                   || '?motsCles='
                                                   || utl_url.escape(in_keywords, true, 'AL32UTF8')
                                                   || co_ampersand
                                                   || 'range='
                                                   || l_range;
        l_params     json_object_t := json_object_t();
        l_request_id collect_requests.request_id%type;
        l_body       clob;
    begin
        l_params.put('motsCles', in_keywords);
        l_params.put('range', l_range);
        << attempts >> for l_attempt in 1..co_max_attempts loop
            -- Visible sans commit dans v$session.action (tronqué par Oracle si trop long)
            dbms_application_info.set_action(in_keywords
                                             || ' '
                                             || l_range
                                             || ' #' || l_attempt);

            l_request_id := collect_staging.open_request(in_run_id, http_util.co_method_get, l_url, l_params.to_json);

            begin
                l_body := http_util.make_rest_request(
                    in_url                  => l_url,
                    in_http_method          => http_util.co_method_get,
                    in_credential_static_id => co_credential_static_id,
                    in_token_url            => co_token_url
                );
            exception
                when others then
                    -- Erreur déjà journalisée par http_util ; trace de la requête
                    collect_staging.close_request(l_request_id, null, null, null, sqlerrm);
                    raise;
            end;

            out_status_code := apex_web_service.g_status_code;
            if out_status_code in ( utl_http.http_ok, utl_http.http_no_content, utl_http.http_partial_content ) then
                collect_staging.close_request(l_request_id, out_status_code, http_util.response_headers, l_body);
                out_total := parse_total(http_util.response_header(http_util.co_header_content_range));
                out_offer_count :=
                    case
                        when out_status_code = utl_http.http_no_content then
                            0
                        else
                            json_object_t.parse(l_body).get_array('resultats').get_size
                    end;

                return;
            end if;

            collect_staging.close_request(l_request_id, out_status_code, http_util.response_headers, l_body, 'HTTP ' || out_status_code
            );

            exit attempts when not http_util.is_retryable(out_status_code)
            or l_attempt = co_max_attempts;
            logger.log_warning('HTTP '
                               || out_status_code
                               || ', attempt '
                               || l_attempt
                               || ': '
                               || l_url, l_scope);

            dbms_session.sleep(http_util.retry_delay(l_attempt,
                                                     http_util.response_header(http_util.co_header_retry_after)));

        end loop attempts;

        raise_application_error(app_errors.co_http_error, 'HTTP '
                                                          || out_status_code
                                                          || ' on '
                                                          || l_url);
    end fetch_page;

    /**
     * Collecte d'une recherche : un run, toutes ses pages. En cas d'erreur,
     * le run passe à FAILED avant que l'erreur soit relancée.
     * @param in_keywords valeur de motsCles (la virgule y est un ET)
     */
    procedure collect_search (
        in_keywords in varchar2
    ) is

        l_scope          logger_logs.scope%type := co_scope_prefix || 'collect_search';
        l_search_params  json_object_t := json_object_t();
        l_run_id         collect_runs.run_id%type;
        l_offset         pls_integer := 0;
        l_status_code    pls_integer;
        l_total          pls_integer;
        l_offer_count    pls_integer;
        l_received_count pls_integer := 0;
    begin
        l_search_params.put('motsCles', in_keywords);
        l_run_id := collect_staging.open_run(co_source_code, l_search_params.to_json);
        begin
            << pages >> loop
                fetch_page(l_run_id, in_keywords, l_offset, l_status_code, l_total,
                           l_offer_count);
                check_page(l_status_code, l_total);
                l_received_count := l_received_count + l_offer_count;
                exit pages when not has_more(l_status_code, l_offset, l_total);
                -- Si la taille de page change, la dernière page est ramenée au plafond
                l_offset := least(l_offset + co_page_size, co_max_offset);
            end loop pages;

            collect_staging.close_run(l_run_id, collect_staging.co_status_succeeded, l_received_count);
            logger.log_info('Search "'
                            || in_keywords
                            || '": '
                            || l_received_count
                            || ' offers', l_scope);

        exception
            when others then
                logger.log_error('Search "'
                                 || in_keywords
                                 || '" failed', l_scope);
                collect_staging.close_run(l_run_id, collect_staging.co_status_failed, l_received_count, sqlerrm);
                raise;
        end;

    end collect_search;

    -- -------------------------------------------------------------------------
    -- Point d'entrée
    -- -------------------------------------------------------------------------

    procedure run is

        l_scope         logger_logs.scope%type := co_scope_prefix || 'run';
        -- Module et action de l'appelant (job, SQLcl), restaurés en fin d'exécution
        l_caller_module varchar2(64 char);
        l_caller_action varchar2(64 char);
        -- Avancement par recherche dans v$session_longops
        l_longops_index binary_integer := dbms_application_info.set_session_longops_nohint;
        l_longops_slot  binary_integer;

        procedure report_progress (
            in_done in pls_integer
        ) is
        begin
            dbms_application_info.set_session_longops(
                rindex      => l_longops_index,
                slno        => l_longops_slot,
                op_name     => 'France Travail collect',
                target_desc =>
                             case
                                 when in_done < co_searches.count then
                                     substrb(
                                         co_searches(in_done + 1),
                                         1,
                                         32
                                     )
                             end,
                sofar       => in_done,
                totalwork   => co_searches.count,
                units       => 'searches'
            );
        end report_progress;

    begin
        dbms_application_info.read_module(l_caller_module, l_caller_action);
        dbms_application_info.set_module(
            module_name => lower($$plsql_unit),
            action_name => 'run'
        );
        app_context.set_apex_workspace;
        << searches >> for i in 1..co_searches.count loop
            report_progress(i - 1);
            collect_search(co_searches(i));
        end loop searches;

        report_progress(co_searches.count);
        commit;
        dbms_application_info.set_module(l_caller_module, l_caller_action);
    exception
        when others then
            -- Résultat partiel inexploitable : on arrête tout, mais on garde la
            -- trace (run FAILED, requêtes) avant de relancer l'erreur
            logger.log_error('France Travail collect failed', l_scope);
            commit;
            dbms_application_info.set_module(l_caller_module, l_caller_action);
            raise;
    end run;

end collect_france_travail;
/


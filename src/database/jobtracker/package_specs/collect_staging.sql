create or replace package jobtracker.collect_staging authid definer is
    /**
     * Traçage générique de la collecte, quelle que soit la source : un run par
     * exécution, une ligne par requête HTTP.
     * Aucun COMMIT : la transaction appartient au point d'entrée appelant.
     */

    -- Statuts d'un run (contrainte collect_runs_status_ck)
    co_status_running constant collect_runs.status%type := 'RUNNING';
    co_status_succeeded constant collect_runs.status%type := 'SUCCEEDED';
    co_status_failed constant collect_runs.status%type := 'FAILED';
    co_status_rejected constant collect_runs.status%type := 'REJECTED';

    /**
     * Ouvre un run au statut RUNNING.
     * @param in_search_params paramètres de la recherche, gardés pour la trace
     * @return identifiant du run
     * @throws app_errors.co_not_found source absente de offer_sources
     */
    function open_run (
        in_source_code   in offer_sources.source_code%type,
        in_search_params in json
    ) return collect_runs.run_id%type;

    /**
     * Clôt un run RUNNING avec son statut final.
     * @throws app_errors.co_invalid_state run inexistant ou déjà clos
     */
    procedure close_run (
        in_run_id               in collect_runs.run_id%type,
        in_status               in collect_runs.status%type,
        in_received_offer_count in collect_runs.received_offer_count%type default null,
        in_error_message        in collect_runs.error_message%type default null
    );

    /**
     * Trace le début d'une requête HTTP, numérotée dans son run.
     * @param in_request_params paramètres de la requête, sans en-tête
     *                          (le jeton OAuth2 n'est jamais stocké)
     * @return identifiant de la requête
     */
    function open_request (
        in_run_id         in collect_runs.run_id%type,
        in_http_method    in collect_requests.http_method%type,
        in_request_url    in collect_requests.request_url%type,
        in_request_params in json
    ) return collect_requests.request_id%type;

    /**
     * Trace la fin d'une requête HTTP.
     * @param in_response_code null si l'appel a échoué avant toute réponse
     * @param in_response_body stocké tel quel s'il est du JSON ; sinon (page
     *                         d'erreur d'un proxy) ajouté à error_message,
     *                         tronqué à 4000 octets
     * @throws app_errors.co_not_found requête inexistante
     */
    procedure close_request (
        in_request_id       in collect_requests.request_id%type,
        in_response_code    in collect_requests.response_code%type,
        in_response_headers in json,
        in_response_body    in clob,
        in_error_message    in varchar2 default null
    );

end collect_staging;
/


-- sqlcl_snapshot {"hash":"2a6269a6d1acd59e8153947d3789b26013015f45","type":"PACKAGE_SPEC","name":"COLLECT_STAGING","schemaName":"JOBTRACKER","sxml":""}
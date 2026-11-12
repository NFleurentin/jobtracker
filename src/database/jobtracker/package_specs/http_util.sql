create or replace package jobtracker.http_util authid definer is
    /**
     * Constantes et fonctions du protocole HTTP, communes aux packages de
     * collecte, pour ce qu'UTL_HTTP ne couvre pas. Les codes de statut
     * qu'UTL_HTTP déclare déjà (utl_http.http_ok, http_no_content,
     * http_partial_content...) s'utilisent directement : référencer ses
     * constantes n'ouvre aucun accès réseau.
     * N'y ajouter que ce qui est utilisé.
     */

    -- Méthodes
    co_method_get constant varchar2(10 char) := 'GET';

    -- En-têtes de réponse
    co_header_content_range constant varchar2(30 char) := 'Content-Range';
    co_header_retry_after constant varchar2(30 char) := 'Retry-After';

    -- Codes de statut postérieurs à la liste d'UTL_HTTP
    co_status_too_many_requests constant pls_integer := 429;

    -- Attente maximale avant un nouvel essai, en secondes, même si
    -- Retry-After demande plus : borne la durée d'un job
    co_max_retry_delay constant pls_integer := 60;

    -- Délai maximal d'un appel, en secondes (180 par défaut dans APEX) : borne
    -- l'attente d'un utilisateur de l'application
    co_transfer_timeout constant pls_integer := 30;

    /**
     * URL complétée de sa query string, paramètres encodés (UTF-8).
     * @param in_url    URL de base ; une query string présente est complétée
     * @param in_params objet JSON {"nom": valeur} ; une valeur tableau répète le
     *                  paramètre ({"type":["CDI","CDD"]} : type=CDI puis type=CDD) ;
     *                  une valeur null est ignorée ; null pour aucun paramètre
     * @return in_url si in_params est null ou vide
     */
    function build_url (
        in_url    in varchar2,
        in_params in json
    ) return varchar2;

    /**
     * Seul point d'appel d'APEX_WEB_SERVICE.MAKE_REST_REQUEST, isolé dans une
     * transaction autonome : obtenir un jeton OAuth2 par un Web Credential met
     * fin à la transaction en cours (ROLLBACK constaté avec APEX 26.1), ce qui
     * effacerait les écritures non validées de l'appelant (job ou page APEX).
     * Chaque appel est tracé dans le journal des échanges (exchange_log) :
     * URL envoyée, méthode, paramètres et en-têtes de requête,
     * code, en-têtes et corps de la réponse, ou erreur. Les en-têtes sensibles
     * (Authorization, Cookie...) sont masqués ; l'URL est stockée telle quelle :
     * ne jamais y passer de secret, ni dans in_params. L'obtention du jeton
     * OAuth2, faite par APEX, n'est pas tracée.
     * Code de statut et en-têtes restent lisibles après l'appel
     * (apex_web_service.g_status_code, response_header, response_headers).
     * @param in_url                  URL de base, complétée par in_params (build_url)
     * @param in_external_system_code système appelé (exchange_log.co_system_)
     * @param in_params               paramètres de la query string, voir build_url ;
     *                                seule saisie : ajoutés à l'URL et journalisés
     * @param in_headers              en-têtes de requête, même forme que in_params ;
     *                                seuls envoyés (apex_web_service.g_request_headers
     *                                est vidé avant et après l'appel)
     * @param in_credential_static_id Web Credential, null pour un appel anonyme
     * @param in_token_url            URL du jeton OAuth2, avec le credential
     * @param in_correlation_id       exchange_log.new_correlation_id, commun aux
     *                                appels d'une même opération ; null pour un
     *                                appel isolé
     * @param in_transfer_timeout     délai maximal en secondes
     * @return corps de la réponse
     * @throws app_errors.e_not_found système inconnu
     */
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
    ) return clob;

    /**
     * Indique si le code de statut est une erreur serveur (classe 5xx).
     * @return false si in_status_code est null
     */
    function is_server_error (
        in_status_code in pls_integer
    ) return boolean;

    /**
     * Politique de nouvel essai par défaut : 429 et 5xx. Une API qui en
     * demande une autre a sa propre fonction dans son package.
     * @return false si in_status_code est null
     */
    function is_retryable (
        in_status_code in pls_integer
    ) return boolean;

    /**
     * Attente avant l'essai suivant.
     * @param in_attempt     numéro de l'essai qui vient d'échouer (1 pour le premier)
     * @param in_retry_after en-tête Retry-After brut ; une date HTTP est ignorée
     * @return secondes : Retry-After s'il est numérique, sinon 2^in_attempt,
     *         plafonné à co_max_retry_delay
     */
    function retry_delay (
        in_attempt     in pls_integer,
        in_retry_after in varchar2
    ) return number;

    /**
     * En-tête de la dernière réponse d'APEX_WEB_SERVICE (g_headers).
     * @param in_name nom de l'en-tête, insensible à la casse
     * @return valeur, null si l'en-tête est absent
     */
    function response_header (
        in_name in varchar2
    ) return varchar2;

    /**
     * En-têtes de la dernière réponse d'APEX_WEB_SERVICE (g_headers), en
     * objet JSON. Un en-tête répété ne garde que sa dernière valeur.
     */
    function response_headers return json;

end http_util;
/


-- sqlcl_snapshot {"hash":"37d948a93f02742b9eb2c60bdc2503bc43ad4a1a","type":"PACKAGE_SPEC","name":"HTTP_UTIL","schemaName":"JOBTRACKER","sxml":""}
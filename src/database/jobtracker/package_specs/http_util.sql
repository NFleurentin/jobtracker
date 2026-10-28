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

    /**
     * Seul point d'appel d'APEX_WEB_SERVICE.MAKE_REST_REQUEST, isolé dans une
     * transaction autonome : obtenir un jeton OAuth2 par un Web Credential met
     * fin à la transaction en cours (ROLLBACK constaté avec APEX 26.1), ce qui
     * effacerait les écritures non validées de l'appelant (job ou page APEX).
     * Code de statut et en-têtes restent lisibles après l'appel
     * (apex_web_service.g_status_code, response_header, response_headers).
     * @param in_credential_static_id Web Credential, null pour un appel anonyme
     * @param in_token_url            URL du jeton OAuth2, avec le credential
     * @return corps de la réponse
     */
    function make_rest_request (
        in_url                  in varchar2,
        in_http_method          in varchar2,
        in_credential_static_id in varchar2 default null,
        in_token_url            in varchar2 default null
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


-- sqlcl_snapshot {"hash":"f6408756723b3efe3f3dca35bad482f67891411d","type":"PACKAGE_SPEC","name":"HTTP_UTIL","schemaName":"JOBTRACKER","sxml":""}
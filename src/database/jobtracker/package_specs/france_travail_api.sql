create or replace package jobtracker.france_travail_api authid definer is
    /**
     * Seul point d'accès aux API de France Travail (offres, référentiels...) :
     * URL de base, Web Credential et jeton OAuth2, politique de nouvel essai.
     * Le jeton est obtenu et mis en cache par APEX, au travers du credential :
     * les appelants n'en savent rien.
     * N'y déclarer que les endpoints utilisés.
     */

    -- Endpoints, relatifs à l'URL de base
    co_endpoint_offer_search constant varchar2(100 char) := '/offresdemploi/v2/offres/search';
    co_endpoint_ref_regions constant varchar2(100 char) := '/offresdemploi/v2/referentiel/regions';
    co_endpoint_ref_departments constant varchar2(100 char) := '/offresdemploi/v2/referentiel/departements';
    co_endpoint_ref_communes constant varchar2(100 char) := '/offresdemploi/v2/referentiel/communes';
    co_endpoint_ref_countries constant varchar2(100 char) := '/offresdemploi/v2/referentiel/pays';
    co_endpoint_ref_continents constant varchar2(100 char) := '/offresdemploi/v2/referentiel/continents';
    co_endpoint_ref_contract_types constant varchar2(100 char) := '/offresdemploi/v2/referentiel/typesContrats';

    -- Nouveaux essais sur 429 et 5xx (http_util.is_retryable)
    co_max_attempts constant pls_integer := 5;

    /**
     * Appel GET d'un endpoint, avec de nouveaux essais sur 429 et 5xx. Chaque
     * essai est tracé dans le journal des échanges (http_util.make_rest_request).
     * Code de statut et en-têtes de la dernière réponse restent lisibles après
     * l'appel (apex_web_service.g_status_code, http_util.response_header) :
     * l'appelant distingue les codes 2xx (200, 204, 206...).
     * Une erreur sans réponse (réseau, délai) n'est pas réessayée.
     * @param in_endpoint       endpoint (co_endpoint_), relatif à l'URL de base
     * @param in_params         paramètres de la query string, voir http_util.build_url
     * @param in_correlation_id exchange_log.new_correlation_id, commun aux appels
     *                          d'une même opération ; null pour un appel isolé
     * @param in_max_attempts   nombre maximal d'essais, 1 (ou null) pour aucun nouvel essai
     * @return corps de la réponse, sur un code 2xx
     * @throws app_errors.co_http_error code hors 2xx non réessayable, ou essais
     *         épuisés ; le motif donné par l'API est lu par last_error_message
     */
    function call (
        in_endpoint       in varchar2,
        in_params         in json default null,
        in_correlation_id in raw default null,
        in_max_attempts   in pls_integer default co_max_attempts
    ) return clob;

    /**
     * Motif d'erreur donné par l'API dans la dernière réponse hors 2xx du
     * dernier appel (call) : champ "message" du corps
     * {"message": ..., "codeHttp": 400, "codeErreur": ...}, en français.
     * @return null si le dernier appel a réussi, n'a reçu aucune réponse, ou
     *         si le corps n'a pas de motif lisible
     */
    function last_error_message return varchar2;

    /**
     * URL complète d'un endpoint, sans paramètre.
     * @param in_endpoint endpoint (co_endpoint_), commençant par "/"
     */
    function endpoint_url (
        in_endpoint in varchar2
    ) return varchar2;

end france_travail_api;
/


-- sqlcl_snapshot {"hash":"af55b0c6e6102de5eaefddc10eb19496809c1959","type":"PACKAGE_SPEC","name":"FRANCE_TRAVAIL_API","schemaName":"JOBTRACKER","sxml":""}
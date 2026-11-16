-- liquibase formatted sql
-- changeset JOBTRACKER:1794839184714 stripComments:false  logicalFilePath:feat/france-travail-api-package/jobtracker/package_specs/france_travail_api.sql
-- sqlcl_snapshot src/database/jobtracker/package_specs/france_travail_api.sql:null:5175c0d57a9fa3537b30b6e588848d22a8020f85:create

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
     * @throws app_errors.co_http_error code hors 2xx non réessayable, ou essais épuisés
     */
    function call (
        in_endpoint       in varchar2,
        in_params         in json default null,
        in_correlation_id in raw default null,
        in_max_attempts   in pls_integer default co_max_attempts
    ) return clob;

    /**
     * URL complète d'un endpoint, sans paramètre.
     * @param in_endpoint endpoint (co_endpoint_), commençant par "/"
     */
    function endpoint_url (
        in_endpoint in varchar2
    ) return varchar2;

end france_travail_api;
/


create or replace package jobtracker.test_http_util authid definer is
    -- =========================================================================
    -- Tests de http_util.
    -- =========================================================================

    --%suite(http_util)

    --%context(is_server_error)

    --%test(vrai aux bornes de la classe 5xx)
    procedure is_server_error_bounds;

    --%test(faux hors de la classe 5xx)
    procedure is_server_error_outside;

    --%test(faux sans code)
    procedure is_server_error_without_code;

    --%endcontext

    --%context(is_retryable)

    --%test(nouvel essai sur 429)
    procedure is_retryable_too_many_requests;

    --%test(nouvel essai sur 500 et 503)
    procedure is_retryable_server_errors;

    --%test(pas de nouvel essai sur 400 et 401)
    procedure is_retryable_client_errors;

    --%test(pas de nouvel essai sans code HTTP)
    procedure is_retryable_without_code;

    --%endcontext

    --%context(retry_delay)

    --%test(attente croissante sans Retry-After)
    procedure retry_delay_exponential;

    --%test(Retry-After en secondes respecté)
    procedure retry_delay_retry_after_seconds;

    --%test(Retry-After plafonné)
    procedure retry_delay_retry_after_capped;

    --%test(Retry-After en date HTTP ignoré)
    procedure retry_delay_retry_after_date;

    --%endcontext

    --%context(response_header)

    --%beforeeach(set_headers)

    --%test(trouve un en-tête sans tenir compte de la casse)
    procedure response_header_case_insensitive;

    --%test(renvoie null pour un en-tête absent)
    procedure response_header_absent;

    --%endcontext

    --%context(response_headers)

    --%beforeeach(set_headers)

    --%test(renvoie les en-têtes en JSON)
    procedure response_headers_as_json;

    --%test(un en-tête répété garde sa dernière valeur)
    procedure response_headers_repeated;

    --%test(objet vide sans en-tête)
    procedure response_headers_empty;

    --%endcontext

    -- Simule les en-têtes d'une réponse d'APEX_WEB_SERVICE
    procedure set_headers;

end test_http_util;
/

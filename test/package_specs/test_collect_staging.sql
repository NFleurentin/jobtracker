create or replace package jobtracker.test_collect_staging authid definer is
    -- =========================================================================
    -- Tests de collect_staging. Chaque test écrit réellement dans les tables
    -- de staging ; utPLSQL annule ses écritures à la fin (rollback auto).
    -- Suppose la source FRANCE_TRAVAIL présente (donnée de référence).
    -- =========================================================================

    --%suite(collect_staging)

    --%context(open_run)

    --%test(crée un run RUNNING, sans fin)
    procedure open_run_creates_running_run;

    --%test(refuse une source inconnue)
    --%throws(app_errors.co_not_found)
    procedure open_run_unknown_source;

    --%endcontext

    --%context(close_run)

    --%test(clôt le run avec son statut, sa fin et son erreur)
    procedure close_run_sets_status;

    --%test(refuse un run déjà clos)
    --%throws(app_errors.co_invalid_state)
    procedure close_run_already_closed;

    --%endcontext

    --%context(open_request)

    --%test(numérote les requêtes dans leur run)
    procedure open_request_numbers_requests;

    --%endcontext

    --%context(close_request)

    --%test(stocke un corps JSON tel quel)
    procedure close_request_json_body;

    --%test(met un corps non JSON dans error_message)
    procedure close_request_non_json_body;

    --%test(sans corps, ni payload ni erreur)
    procedure close_request_empty_body;

    --%test(tronque un corps non JSON trop long)
    procedure close_request_truncates_body;

    --%test(refuse une requête inconnue)
    --%throws(app_errors.co_not_found)
    procedure close_request_unknown_request;

    --%endcontext
end test_collect_staging;
/

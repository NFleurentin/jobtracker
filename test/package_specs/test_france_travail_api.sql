create or replace package jobtracker.test_france_travail_api authid definer is
    -- =========================================================================
    -- Tests de france_travail_api, sans appel réseau : la routine call, qui
    -- appelle l'API, se valide en dev par la collecte (README).
    -- =========================================================================

    --%suite(france_travail_api)

    --%context(endpoint_url)

    --%test(URL de base complétée de l'endpoint)
    procedure endpoint_url_offer_search;

    --%endcontext
end test_france_travail_api;
/

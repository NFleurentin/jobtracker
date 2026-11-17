create or replace package jobtracker.test_external_system_api authid definer is
    -- =========================================================================
    -- Tests de external_system_api. Chaque test modifie réellement le système
    -- France Travail des données de référence ; utPLSQL annule ses écritures
    -- à la fin (rollback auto).
    -- =========================================================================

    --%suite(external_system_api)

    --%context(update_external_system)

    --%test(remplace les paramètres du journal)
    procedure update_replaces_settings;

    --%test(refuse un système inconnu)
    --%throws(app_errors.co_not_found)
    procedure update_unknown;

    --%test(refuse une rétention hors bornes)
    --%throws(-2290)
    procedure update_retention_out_of_range;

    --%test(refuse un délai des orphelins hors bornes)
    --%throws(-2290)
    procedure update_orphan_delay_out_of_range;

    --%endcontext
end test_external_system_api;
/

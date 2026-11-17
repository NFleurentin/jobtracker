create or replace package jobtracker.test_ft_referential_loads authid definer is
    -- =========================================================================
    -- Tests des contraintes de ft_referential_loads : statut et fin posés
    -- ensemble, statut parmi les valeurs prévues, fin après le début.
    -- Chaque test écrit réellement dans la table ; utPLSQL annule ses
    -- écritures à la fin (rollback auto).
    -- =========================================================================

    --%suite(ft_referential_loads)

    --%test(ouvre un chargement sans fin ni statut, daté par défaut)
    procedure running_load_accepted;

    --%test(clôt un chargement avec chacun des statuts prévus)
    procedure statuses_accepted;

    --%test(refuse un statut inconnu)
    --%throws(-2290)
    procedure unknown_status_rejected;

    --%test(refuse une fin sans statut)
    --%throws(-2290)
    procedure end_without_status_rejected;

    --%test(refuse un statut sans fin)
    --%throws(-2290)
    procedure status_without_end_rejected;

    --%test(refuse une fin antérieure au début)
    --%throws(-2290)
    procedure end_before_start_rejected;

end test_ft_referential_loads;
/

create or replace package jobtracker.test_ft_referential_load_details authid definer is
    -- =========================================================================
    -- Tests de la vue ft_referential_load_details : état d'un chargement
    -- (terminé, interrompu), nombre de référentiels en erreur, dernier
    -- chargement. L'état RUNNING demande le job, donc un COMMIT (DDL) : il se
    -- valide à la main en dev. Ces tests supposent qu'aucun chargement ne
    -- tourne. utPLSQL annule leurs écritures à la fin.
    -- =========================================================================

    --%suite(ft_referential_load_details)

    --%test(rend le statut d'un chargement terminé)
    procedure ended_load_status;

    --%test(rend interrompu le dernier chargement non terminé sans job)
    procedure latest_unfinished_interrupted;

    --%test(rend interrompu un chargement non terminé antérieur)
    procedure older_unfinished_interrupted;

    --%test(compte les référentiels en erreur)
    procedure errors_counted;

    --%test(compte zéro erreur sans détail par référentiel)
    procedure no_referentials_no_error;

    --%test(marque seul le dernier chargement)
    procedure only_latest_marked;

end test_ft_referential_load_details;
/

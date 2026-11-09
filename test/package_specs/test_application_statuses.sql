create or replace package jobtracker.test_application_statuses authid definer is
    -- =========================================================================
    -- Tests des contraintes de application_statuses, liste fixe sans package
    -- d'écriture. Suppose les données de référence ; chaque test écrit
    -- réellement dans la table, utPLSQL annule ses écritures (rollback auto).
    -- =========================================================================

    --%suite(application_statuses)

    --%test(charge les statuts de départ, avec leur étape de funnel et leur caractère final)
    procedure reference_statuses_loaded;

    --%test(refuse un code en double)
    procedure code_unique;

    --%test(refuse un libellé français en double)
    procedure name_fr_unique;

    --%test(refuse un libellé anglais en double)
    procedure name_en_unique;

    --%test(refuse un ordre d'affichage en double)
    procedure display_order_unique;

    --%test(refuse une étape de funnel en double)
    procedure funnel_step_unique;

    --%test(accepte plusieurs statuts hors funnel)
    procedure funnel_step_null_repeatable;

    --%test(refuse une étape de funnel nulle ou négative)
    --%throws(-2290)
    procedure funnel_step_positive;

    --%test(exige le code)
    --%throws(-1400)
    procedure code_required;

    --%test(exige le libellé français)
    --%throws(-1400)
    procedure name_fr_required;

    --%test(exige le libellé anglais)
    --%throws(-1400)
    procedure name_en_required;

    --%test(exige l'ordre d'affichage)
    --%throws(-1400)
    procedure display_order_required;

    --%test(exige le caractère final)
    --%throws(-1400)
    procedure is_final_required;

end test_application_statuses;
/

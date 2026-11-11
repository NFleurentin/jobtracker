create or replace package jobtracker.test_work_modes authid definer is
    -- =========================================================================
    -- Tests des contraintes de work_modes, liste fixe sans package
    -- d'écriture. Suppose les données de référence ; chaque test écrit
    -- réellement dans la table, utPLSQL annule ses écritures (rollback auto).
    -- =========================================================================

    --%suite(work_modes)

    --%test(charge les modes de départ par leur code)
    procedure reference_codes_loaded;

    --%test(refuse un code en double)
    procedure code_unique;

    --%test(refuse un libellé français en double)
    procedure name_fr_unique;

    --%test(refuse un libellé anglais en double)
    procedure name_en_unique;

    --%test(exige le code)
    --%throws(-1400)
    procedure code_required;

    --%test(exige le libellé français)
    --%throws(-1400)
    procedure name_fr_required;

    --%test(exige le libellé anglais)
    --%throws(-1400)
    procedure name_en_required;

end test_work_modes;
/

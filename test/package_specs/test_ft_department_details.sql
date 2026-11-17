create or replace package jobtracker.test_ft_department_details authid definer is
    -- =========================================================================
    -- Tests de la vue ft_department_details : un code est courant s'il porte le
    -- dernier chargement de sa table (départements). Chaque test écrit réellement
    -- dans les tables ; utPLSQL annule ses écritures à la fin (rollback auto).
    -- =========================================================================

    --%suite(ft_department_details)

    --%test(rend courant un code du dernier chargement)
    procedure latest_load_current;

    --%test(rend non courant un code absent du dernier chargement)
    procedure missing_code_not_current;

    --%test(garde courants les codes quand un chargement ne les touche pas)
    procedure untouched_load_keeps_current;

    --%test(rend de nouveau courant un code réapparu)
    procedure reappeared_code_current;

    --%test(accepte un rattachement nul)
    procedure null_region_accepted;

    --%test(refuse un rattachement à un code inconnu)
    --%throws(-2291)
    procedure unknown_region_rejected;

end test_ft_department_details;
/

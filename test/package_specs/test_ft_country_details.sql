create or replace package jobtracker.test_ft_country_details authid definer is
    -- =========================================================================
    -- Tests de la vue ft_country_details : un code est courant s'il porte le
    -- dernier chargement de sa table (pays). Chaque test écrit réellement
    -- dans les tables ; utPLSQL annule ses écritures à la fin (rollback auto).
    -- =========================================================================

    --%suite(ft_country_details)

    --%test(rend courant un code du dernier chargement)
    procedure latest_load_current;

    --%test(rend non courant un code absent du dernier chargement)
    procedure missing_code_not_current;

    --%test(garde courants les codes quand un chargement ne les touche pas)
    procedure untouched_load_keeps_current;

    --%test(rend de nouveau courant un code réapparu)
    procedure reappeared_code_current;

end test_ft_country_details;
/

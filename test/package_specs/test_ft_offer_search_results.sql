create or replace package jobtracker.test_ft_offer_search_results authid definer is
    -- =========================================================================
    -- Tests de la vue ft_offer_search_results : champs scalaires des offres
    -- de la collection de recherche, une ligne par offre, et libellé de
    -- l'origine lu dans ft_offer_origins.
    -- Collection remplie par ft_offer_search.load_offers sur des fixtures :
    -- un écart entre le nom en dur dans la vue et la constante du package
    -- vide la vue et fait échouer les tests. Session APEX ouverte par test.
    -- Suppose les données de référence de ft_offer_origins.
    -- =========================================================================

    --%suite(ft_offer_search_results)
    --%beforeeach(test_helpers.start_english_session)
    --%aftereach(test_helpers.end_english_session)

    --%test(lit chaque champ de l'offre dans sa colonne)
    procedure all_fields_mapped;

    --%test(rend null pour un champ absent)
    procedure missing_fields_null;

    --%test(rend un libellé d'origine null pour un code absent du référentiel)
    procedure unknown_origin_without_name;

    --%test(garde l'ordre de l'API)
    procedure api_order_kept;

    --%test(ignore les autres collections de la session)
    procedure other_collection_ignored;

end test_ft_offer_search_results;
/

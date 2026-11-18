create or replace package jobtracker.test_ft_offer_search_result_items authid definer is
    -- =========================================================================
    -- Tests de la vue ft_offer_search_result_items : éléments des tableaux
    -- des offres de la collection de recherche, une ligne par élément.
    -- Collection remplie par ft_offer_search.load_offers sur des fixtures.
    -- Session APEX ouverte par test.
    -- =========================================================================

    --%suite(ft_offer_search_result_items)
    --%beforeeach(test_helpers.start_english_session)
    --%aftereach(test_helpers.end_english_session)

    --%test(lit chaque tableau de l'offre sous son type)
    procedure each_array_typed;

    --%test(lit les champs de chaque type dans leur colonne)
    procedure item_fields_mapped;

    --%test(garde l'ordre des éléments dans leur tableau)
    procedure array_order_kept;

    --%test(n'a aucune ligne pour une offre sans tableau)
    procedure offer_without_arrays;

end test_ft_offer_search_result_items;
/

create or replace package jobtracker.test_company_details authid definer is
    -- =========================================================================
    -- Tests de la vue company_details : jointures externes et libellés.
    -- Chaque test écrit réellement dans companies (et locations, sans package
    -- d'écriture) ; utPLSQL annule ses écritures à la fin (rollback auto).
    -- Suppose les données de référence de company_types, sectors,
    -- company_sizes, location_types et jobs.
    -- =========================================================================

    --%suite(company_details)

    --%test(garde une entreprise sans référentiel ni parent, libellés vides)
    procedure company_without_references;

    --%test(remonte les libellés des référentiels et du parent)
    procedure company_with_all_references;

    --%test(donne une seule ligne par entreprise)
    procedure one_row_per_company;

    --%test(compte les postes de contacts dans l'entreprise, zéro sans poste)
    procedure position_count;

    --%test(remonte les libellés anglais dans une session APEX en anglais)
    --%beforetest(test_helpers.start_english_session)
    --%aftertest(test_helpers.end_english_session)
    procedure labels_in_english_session;

end test_company_details;
/

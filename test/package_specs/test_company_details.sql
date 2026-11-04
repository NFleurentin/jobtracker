create or replace package jobtracker.test_company_details authid definer is
    -- =========================================================================
    -- Tests de la vue company_details : jointures externes et libellés.
    -- Chaque test écrit réellement dans companies (et locations, sans package
    -- d'écriture) ; utPLSQL annule ses écritures à la fin (rollback auto).
    -- Suppose les données de référence de company_types, sectors,
    -- company_sizes et location_types.
    -- =========================================================================

    --%suite(company_details)

    --%test(garde une entreprise sans référentiel ni parent, libellés vides)
    procedure company_without_references;

    --%test(remonte les libellés des référentiels et du parent)
    procedure company_with_all_references;

    --%test(donne une seule ligne par entreprise)
    procedure one_row_per_company;

    --%test(remonte les libellés anglais dans une session APEX en anglais)
    --%beforetest(start_english_session)
    --%aftertest(end_english_session)
    procedure labels_in_english_session;

    -- Ouvre une session APEX en anglais, en transaction autonome :
    -- create_session fait un commit quand une session APEX a déjà été
    -- détachée dans la même session de base (constaté en enchaînant les
    -- suites), ce qui empêcherait le rollback automatique d'utPLSQL
    procedure start_english_session;

    -- Détache la session APEX ouverte par un test, en transaction autonome :
    -- detach et delete_session font un commit, qui empêcherait le rollback
    -- automatique d'utPLSQL
    procedure end_english_session;

end test_company_details;
/

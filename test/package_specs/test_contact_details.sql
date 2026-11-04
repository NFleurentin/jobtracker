create or replace package jobtracker.test_contact_details authid definer is
    -- =========================================================================
    -- Tests de la vue contact_details : jointure externe et libellés.
    -- Chaque test écrit réellement dans contacts ; utPLSQL annule ses
    -- écritures à la fin (rollback auto).
    -- Suppose les données de référence de salutations.
    -- =========================================================================

    --%suite(contact_details)

    --%test(garde un contact sans civilité, libellés vides)
    procedure contact_without_salutation;

    --%test(remonte les libellés français de la civilité)
    procedure salutation_labels_in_french;

    --%test(remonte les libellés anglais dans une session APEX en anglais)
    --%beforetest(test_helpers.start_english_session)
    --%aftertest(test_helpers.end_english_session)
    procedure salutation_labels_in_english_session;

end test_contact_details;
/

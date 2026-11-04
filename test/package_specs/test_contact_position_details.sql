create or replace package jobtracker.test_contact_position_details authid definer is
    -- =========================================================================
    -- Tests de la vue contact_position_details : jointures et libellé du poste.
    -- Chaque test écrit réellement dans contacts, companies et
    -- contact_positions ; utPLSQL annule ses écritures à la fin (rollback
    -- auto).
    -- Suppose les données de référence de jobs.
    -- =========================================================================

    --%suite(contact_position_details)

    --%test(remonte le contact, l'entreprise et l'indicateur du poste)
    procedure position_with_contact_and_company;

    --%test(donne une ligne par poste)
    procedure one_row_per_position;

    --%test(remonte le libellé français du poste)
    procedure job_name_in_french;

    --%test(remonte le libellé anglais dans une session APEX en anglais)
    --%beforetest(test_helpers.start_english_session)
    --%aftertest(test_helpers.end_english_session)
    procedure job_name_in_english_session;

end test_contact_position_details;
/

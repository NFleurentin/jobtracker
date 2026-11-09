create or replace package jobtracker.test_application_details authid definer is
    -- =========================================================================
    -- Tests de la vue application_details : jointures, libellés et statut
    -- courant calculé depuis l'historique.
    -- Chaque test écrit réellement dans companies, applications et
    -- application_status_changes ; utPLSQL annule ses écritures à la fin
    -- (rollback auto).
    -- Suppose les données de référence de application_types et de
    -- application_statuses.
    -- =========================================================================

    --%suite(application_details)

    --%test(remonte l'entreprise, le type et le statut courant)
    procedure application_with_company_type_and_status;

    --%test(donne une ligne par candidature, quel que soit l'historique)
    procedure one_row_per_application;

    --%test(le statut courant est le changement le plus récent, pas le dernier saisi)
    procedure current_status_is_latest_changed_at;

    --%test(à date égale, le dernier identifiant l'emporte)
    procedure current_status_tie_broken_by_id;

    --%test(remonte les libellés français)
    procedure labels_in_french;

    --%test(remonte les libellés anglais dans une session APEX en anglais)
    --%beforetest(test_helpers.start_english_session)
    --%aftertest(test_helpers.end_english_session)
    procedure labels_in_english_session;

end test_application_details;
/

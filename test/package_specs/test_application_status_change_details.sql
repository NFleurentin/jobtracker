create or replace package jobtracker.test_application_status_change_details authid definer is
    -- =========================================================================
    -- Tests de la vue application_status_change_details : jointure, libellés
    -- et repérage du dernier changement, seul corrigeable.
    -- Chaque test écrit réellement dans companies, applications et
    -- application_status_changes ; utPLSQL annule ses écritures à la fin
    -- (rollback auto).
    -- Suppose les données de référence de application_types et de
    -- application_statuses.
    -- =========================================================================

    --%suite(application_status_change_details)

    --%test(donne une ligne par changement de statut)
    procedure one_row_per_change;

    --%test(un seul changement est le dernier)
    procedure single_latest_change;

    --%test(le dernier changement est le plus récent, pas le dernier saisi)
    procedure latest_is_latest_changed_at;

    --%test(à date égale, le dernier identifiant l'emporte)
    procedure latest_tie_broken_by_id;

    --%test(le dernier changement est le statut courant de application_details)
    procedure latest_matches_current_status;

    --%test(remonte les libellés français)
    procedure labels_in_french;

    --%test(remonte les libellés anglais dans une session APEX en anglais)
    --%beforetest(test_helpers.start_english_session)
    --%aftertest(test_helpers.end_english_session)
    procedure labels_in_english_session;

end test_application_status_change_details;
/

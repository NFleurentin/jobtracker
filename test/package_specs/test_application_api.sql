create or replace package jobtracker.test_application_api authid definer is
    -- =========================================================================
    -- Tests de application_api. Chaque test écrit réellement dans companies,
    -- applications et application_status_changes ; utPLSQL annule ses
    -- écritures à la fin (rollback auto).
    -- Suppose les données de référence de application_types et de
    -- application_statuses, et l'entreprise générique.
    -- Les verrous et leur délai d'attente ne sont pas testés : il faudrait
    -- deux sessions.
    -- =========================================================================

    --%suite(application_api)

    --%context(create_application)

    --%test(crée la candidature et son statut initial)
    procedure create_application_with_initial_status;

    --%test(enregistre la date du statut initial)
    procedure create_application_backdated;

    --%test(refuse une entreprise inconnue)
    --%throws(app_errors.co_not_found)
    procedure create_application_unknown_company;

    --%test(refuse une deuxième candidature ouverte pour l'entreprise)
    --%throws(app_errors.co_duplicate_value)
    procedure create_application_second_open;

    --%test(nomme l'entreprise dans le message de refus)
    procedure create_application_second_open_message;

    --%test(n'enregistre rien en cas de refus)
    procedure create_application_refused_leaves_nothing;

    --%test(accepte une candidature quand la précédente est close)
    procedure create_application_after_closed;

    --%test(accepte une candidature close quand une autre est ouverte)
    procedure create_application_closed_beside_open;

    --%test(accepte plusieurs candidatures ouvertes pour l'entreprise générique)
    procedure create_application_generic_company;

    --%endcontext

    --%context(update_application)

    --%test(remplace les colonnes, null efface la valeur)
    procedure update_application_replaces_columns;

    --%test(met à jour updated_at, pas created_at)
    procedure update_application_sets_updated_at;

    --%test(refuse une candidature inconnue)
    --%throws(app_errors.co_not_found)
    procedure update_application_unknown;

    --%test(refuse de déplacer une candidature ouverte vers une entreprise qui en a une)
    --%throws(app_errors.co_duplicate_value)
    procedure update_application_move_open;

    --%test(accepte de déplacer une candidature close)
    procedure update_application_move_closed;

    --%endcontext

    --%context(delete_application)

    --%test(supprime la candidature et son historique)
    procedure delete_application_with_history;

    --%test(refuse une candidature inconnue)
    --%throws(app_errors.co_not_found)
    procedure delete_application_unknown;

    --%endcontext

    --%context(add_status_change)

    --%test(le nouveau statut devient le statut courant)
    procedure add_status_change_becomes_current;

    --%test(un statut antidaté ne change pas le statut courant)
    procedure add_status_change_backdated;

    --%test(met à jour updated_at de la candidature)
    procedure add_status_change_sets_updated_at;

    --%test(refuse une candidature inconnue)
    --%throws(app_errors.co_not_found)
    procedure add_status_change_unknown;

    --%test(refuse de rouvrir une candidature quand une autre est ouverte)
    --%throws(app_errors.co_duplicate_value)
    procedure add_status_change_reopens;

    --%test(n'enregistre rien en cas de refus)
    procedure add_status_change_refused_leaves_nothing;

    --%endcontext

    --%context(correct_latest_status_change)

    --%test(corrige le statut initial)
    procedure correct_initial_status;

    --%test(corrige la date du plus récent)
    procedure correct_latest_date;

    --%test(refuse un changement qui n'est pas le plus récent)
    --%throws(app_errors.co_protected_row)
    procedure correct_not_latest;

    --%test(refuse une date antérieure au changement précédent)
    --%throws(app_errors.co_protected_row)
    procedure correct_before_previous;

    --%test(refuse de rouvrir une candidature quand une autre est ouverte)
    --%throws(app_errors.co_duplicate_value)
    procedure correct_reopens;

    --%endcontext

    --%context(update_status_note)

    --%test(remplace la note, sans toucher au statut ni à la date)
    procedure update_status_note_replaces_note;

    --%test(refuse un changement inconnu)
    --%throws(app_errors.co_not_found)
    procedure update_status_note_unknown;

    --%endcontext

    --%context(delete_status_change)

    --%test(supprimer le dernier changement rend le statut précédent courant)
    procedure delete_status_change_previous_current;

    --%test(refuse de supprimer le seul changement)
    --%throws(app_errors.co_protected_row)
    procedure delete_status_change_only_one;

    --%test(explique le refus dans un message lisible)
    procedure delete_status_change_only_one_message;

    --%test(refuse un changement qui n'est pas le plus récent)
    --%throws(app_errors.co_protected_row)
    procedure delete_status_change_not_latest;

    --%test(refuse un changement inconnu)
    --%throws(app_errors.co_not_found)
    procedure delete_status_change_unknown;

    --%test(refuse de rouvrir une candidature quand une autre est ouverte)
    --%throws(app_errors.co_duplicate_value)
    procedure delete_status_change_reopens;

    --%test(n'enregistre rien en cas de refus)
    procedure delete_status_change_refused_leaves_nothing;

    --%endcontext

    --%context(entreprise)

    --%test(refuse de supprimer une entreprise qui a des candidatures)
    --%throws(app_errors.co_row_referenced)
    procedure delete_company_with_applications;

    --%endcontext

    --%context(contraintes des tables)

    --%test(exige un intitulé de poste)
    --%throws(-1400)
    procedure job_title_required;

    --%test(refuse un intérêt hors de 1 à 5)
    --%throws(-2290)
    procedure interest_rating_range;

    --%test(refuse un salaire négatif)
    --%throws(-2290)
    procedure annual_salary_positive;

    --%test(refuse un TJM nul)
    --%throws(-2290)
    procedure daily_rate_positive;

    --%test(exige la date d'un changement de statut)
    --%throws(-1400)
    procedure changed_at_required;

    --%endcontext
end test_application_api;
/

create or replace package jobtracker.test_job_api authid definer is
    -- =========================================================================
    -- Tests de job_api. Chaque test écrit réellement dans jobs ;
    -- utPLSQL annule ses écritures à la fin (rollback auto).
    -- Libellés propres aux tests, absents des données de référence.
    -- =========================================================================

    --%suite(job_api)

    --%context(create_job)

    --%test(crée un poste avec ses deux libellés)
    procedure create_job_both_names;

    --%test(refuse un libellé anglais qui ne diffère que par la casse)
    --%throws(app_errors.co_duplicate_value)
    procedure create_job_duplicate_en;

    --%test(refuse un libellé français qui ne diffère que par la casse)
    --%throws(app_errors.co_duplicate_value)
    procedure create_job_duplicate_fr;

    --%test(nomme le libellé en double dans le message)
    procedure create_job_duplicate_message;

    --%test(exige les deux libellés)
    --%throws(-1400)
    procedure create_job_names_required;

    --%endcontext

    --%context(update_job)

    --%test(remplace les libellés)
    procedure update_job_replaces_names;

    --%test(accepte un changement de casse de son propre libellé)
    procedure update_job_own_name_case;

    --%test(refuse le libellé d'un autre poste à la casse près)
    --%throws(app_errors.co_duplicate_value)
    procedure update_job_duplicate;

    --%test(refuse un poste inconnu)
    --%throws(app_errors.co_not_found)
    procedure update_job_unknown;

    --%endcontext

    --%context(delete_job)

    --%test(supprime le poste)
    procedure delete_job_removes_row;

    --%test(refuse un poste inconnu)
    --%throws(app_errors.co_not_found)
    procedure delete_job_unknown;

    --%test(refuse un poste occupé et le nomme dans le message)
    procedure delete_job_in_use;

    --%endcontext
end test_job_api;
/

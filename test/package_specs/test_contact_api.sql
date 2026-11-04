create or replace package jobtracker.test_contact_api authid definer is
    -- =========================================================================
    -- Tests de contact_api. Chaque test écrit réellement dans contacts ;
    -- utPLSQL annule ses écritures à la fin (rollback auto).
    -- Suppose les données de référence de salutations.
    -- =========================================================================

    --%suite(contact_api)

    --%context(create_contact)

    --%test(crée un contact avec son seul nom)
    procedure create_contact_last_name_only;

    --%test(enregistre toutes les colonnes)
    procedure create_contact_all_columns;

    --%endcontext

    --%context(update_contact)

    --%test(remplace les colonnes, null efface la valeur)
    procedure update_contact_replaces_columns;

    --%test(met à jour updated_at, pas created_at)
    procedure update_contact_sets_updated_at;

    --%test(refuse un contact inconnu)
    --%throws(app_errors.co_not_found)
    procedure update_contact_unknown;

    --%endcontext

    --%context(delete_contact)

    --%test(supprime le contact)
    procedure delete_contact_removes_row;

    --%test(refuse un contact inconnu)
    --%throws(app_errors.co_not_found)
    procedure delete_contact_unknown;

    --%test(refuse un contact qui a des postes)
    --%throws(app_errors.co_row_referenced)
    procedure delete_contact_with_positions;

    --%test(nomme le contact dans le message de refus)
    procedure delete_contact_error_names_contact;

    --%test(supprime aussi ses postes sur demande)
    procedure delete_contact_deletes_positions;

    --%endcontext

    --%context(postes)

    --%test(crée un poste avec toutes ses colonnes)
    procedure create_position_all_columns;

    --%test(accepte plusieurs postes actuels, dans plusieurs entreprises)
    procedure create_position_several_current;

    --%test(refuse le même poste deux fois dans la même entreprise)
    --%throws(-1)
    procedure create_position_duplicate;

    --%test(remplace les colonnes et met à jour updated_at)
    procedure update_position_replaces_columns;

    --%test(refuse un poste inconnu en modification)
    --%throws(app_errors.co_not_found)
    procedure update_position_unknown;

    --%test(supprime le poste)
    procedure delete_position_removes_row;

    --%test(refuse un poste inconnu en suppression)
    --%throws(app_errors.co_not_found)
    procedure delete_position_unknown;

    --%endcontext

    --%context(contraintes de la table)

    --%test(exige un nom)
    --%throws(-1400)
    procedure last_name_required;

    --%test(refuse une civilité inconnue)
    --%throws(-2291)
    procedure salutation_must_exist;

    --%test(refuse une URL LinkedIn complète)
    --%throws(-2290)
    procedure linkedin_slug_format;

    --%endcontext
end test_contact_api;
/

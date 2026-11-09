create or replace package jobtracker.test_company_api authid definer is
    -- =========================================================================
    -- Tests de company_api. Chaque test écrit réellement dans companies ;
    -- utPLSQL annule ses écritures à la fin (rollback auto).
    -- Suppose les données de référence de company_types et de sectors.
    -- =========================================================================

    --%suite(company_api)

    --%context(create_company)

    --%test(crée une entreprise avec son seul nom)
    procedure create_company_name_only;

    --%test(enregistre toutes les colonnes)
    procedure create_company_all_columns;

    --%endcontext

    --%context(update_company)

    --%test(remplace les colonnes, null efface la valeur)
    procedure update_company_replaces_columns;

    --%test(met à jour updated_at, pas created_at)
    procedure update_company_sets_updated_at;

    --%test(refuse une entreprise inconnue)
    --%throws(app_errors.co_not_found)
    procedure update_company_unknown;

    --%test(accepte un parent sans cycle)
    procedure update_company_valid_parent;

    --%test(accepte de retirer le parent)
    procedure update_company_clears_parent;

    --%test(refuse une entreprise parente d'elle-même)
    --%throws(app_errors.co_circular_reference)
    procedure update_company_self_parent;

    --%test(refuse un cycle direct)
    --%throws(app_errors.co_circular_reference)
    procedure update_company_direct_cycle;

    --%test(refuse un cycle sur plusieurs niveaux)
    --%throws(app_errors.co_circular_reference)
    procedure update_company_long_cycle;

    --%test(nomme les deux entreprises dans le message de cycle)
    procedure update_company_cycle_names_companies;

    --%endcontext

    --%context(delete_company)

    --%test(supprime l'entreprise)
    procedure delete_company_removes_row;

    --%test(refuse une entreprise inconnue)
    --%throws(app_errors.co_not_found)
    procedure delete_company_unknown;

    --%test(refuse une entreprise référencée)
    --%throws(app_errors.co_row_referenced)
    procedure delete_company_referenced;

    --%test(explique le refus dans un message lisible)
    procedure delete_company_readable_error;

    --%test(nomme l'entreprise dans le message de refus)
    procedure delete_company_error_names_company;

    --%test(refuse une entreprise où des contacts ont des postes)
    --%throws(app_errors.co_row_referenced)
    procedure delete_company_with_positions;

    --%test(supprime aussi les postes sur demande)
    procedure delete_company_deletes_positions;

    --%test(garde les postes si une filiale bloque la suppression)
    procedure delete_company_parent_keeps_positions;

    --%test(refuse de supprimer l'entreprise générique)
    --%throws(app_errors.co_protected_row)
    procedure delete_company_generic;

    --%test(explique le refus de supprimer l'entreprise générique)
    procedure delete_company_generic_readable_error;

    --%endcontext

    --%context(entreprise générique)

    --%test(existe, créée par la migration)
    procedure generic_company_exists;

    --%test(se renomme comme une autre entreprise)
    procedure generic_company_renamable;

    --%test(refuse une deuxième entreprise générique)
    --%throws(-1)
    procedure generic_company_unique;

    --%test(une entreprise créée n'est pas générique)
    procedure create_company_not_generic;

    --%endcontext

    --%context(contraintes de la table)

    --%test(exige un nom)
    --%throws(-1400)
    procedure company_name_required;

    --%test(refuse un SIREN en double)
    --%throws(-1)
    procedure siren_unique;

    --%test(refuse un SIREN mal formé)
    --%throws(-2290)
    procedure siren_format;

    --%test(refuse une URL LinkedIn complète)
    --%throws(-2290)
    procedure linkedin_slug_format;

    --%endcontext
end test_company_api;
/

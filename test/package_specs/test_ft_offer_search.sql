create or replace package jobtracker.test_ft_offer_search authid definer is
    -- =========================================================================
    -- Tests de ft_offer_search.build_params, sans appel réseau : contrôle des
    -- filtres et paramètres produits.
    -- =========================================================================

    --%suite(ft_offer_search)

    --%context(paramètres produits)

    --%test(rend un objet vide sans aucun filtre)
    procedure no_filter_empty;

    --%test(rend chaque filtre sous son nom dans l'API)
    procedure all_filters_mapped;

    --%test(joint les listes par des virgules, sans espaces ni éléments vides)
    procedure lists_cleaned_and_joined;

    --%test(garde un mot-clé de plusieurs mots, séparés par des espaces)
    procedure keyword_with_spaces;

    --%test(envoie temps partiel et offres pourvues, mais pas inclureLimitrophes à false)
    procedure false_booleans;

    --%test(laisse à l'API ses limites : nombre de mots-clés, de codes, critères de lieu)
    procedure api_limits_not_checked;

    --%endcontext

    --%context(filtre sans le filtre dont il dépend)

    --%test(refuse une distance sans commune)
    --%throws(app_errors.co_invalid_input)
    procedure distance_without_commune;

    --%test(refuse les départements limitrophes sans département)
    --%throws(app_errors.co_invalid_input)
    procedure bordering_without_department;

    --%test(refuse un salaire minimum sans période)
    --%throws(app_errors.co_invalid_input)
    procedure salary_without_period;

    --%test(refuse une période sans salaire minimum)
    --%throws(app_errors.co_invalid_input)
    procedure period_without_salary;

    --%test(trouve chaque message de refus dans le catalogue)
    procedure messages_in_catalog;

    --%endcontext
end test_ft_offer_search;
/

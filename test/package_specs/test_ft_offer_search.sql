create or replace package jobtracker.test_ft_offer_search authid definer is
    -- =========================================================================
    -- Tests de ft_offer_search, sans appel réseau : contrôle des filtres et
    -- paramètres produits (build_params), lecture du total (parse_total) et
    -- chargement d'une page dans la collection (load_offers, sur fixtures).
    -- search enchaîne les appels à l'API : vérifiée à la main en dev.
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

    --%context(filtres saisis dans une page APEX)

    --%test(rend tous les filtres nuls sans aucune saisie)
    procedure page_no_filter_null;

    --%test(rend chaque filtre dans son champ du record, le pays dans paysContinent)
    procedure page_filters_mapped;

    --%test(découpe les listes au séparateur des items multivalués)
    procedure page_lists_split;

    --%test(convertit TRUE et FALSE en booléens)
    procedure page_booleans_converted;

    --%test(refuse une valeur hors de TRUE et FALSE)
    --%throws(app_errors.co_invalid_input)
    procedure page_invalid_boolean;

    --%test(produit les paramètres de l'API depuis la saisie de la page)
    procedure page_params_built;

    --%endcontext

    --%context(total lu dans Content-Range)

    --%test(lit le total après la barre oblique)
    procedure total_parsed;

    --%test(rend null sans en-tête ou sur un en-tête illisible)
    procedure total_unreadable;

    --%endcontext

    --%context(chargement d'une page dans la collection)
    --%beforeeach(test_helpers.start_english_session)
    --%aftereach(test_helpers.end_english_session)

    --%test(charge chaque offre : identifiant dans c001, JSON brut dans clob001)
    procedure offers_loaded;

    --%test(rend 0 pour une page sans offre ou sans corps)
    procedure no_offer_loaded;

    --%test(ajoute les offres d'une page à celles déjà chargées)
    procedure offers_appended;

    --%test(refuse un corps qui n'est pas du JSON)
    --%throws(-40441)
    procedure invalid_body;

    --%endcontext
end test_ft_offer_search;
/

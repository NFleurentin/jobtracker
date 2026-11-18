create or replace package jobtracker.ft_offer_search authid definer is
    /**
     * Recherche d'offres dans l'API France Travail (/v2/offres/search) :
     * contrôle des filtres saisis et construction des paramètres de l'appel.
     * Seuls sont contrôlés, avant l'appel, les filtres que l'API ignorerait
     * sans rien dire (distance sans commune...). Les limites de l'API (nombre
     * de mots-clés, de communes, valeurs admises...) sont laissées à l'API,
     * qui les refuse par une erreur 400 : elles évoluent sans nous.
     * Comportements constatés sur l'API le 18/11/2026.
     */

    /**
     * Filtres d'une recherche, tous facultatifs (null : filtre absent).
     * Une liste de codes vient d'un item APEX multivalué par
     * apex_string.split ; ses éléments vides sont ignorés.
     */
    type t_filters_type is record (
            -- motsCles : mots-clés séparés par des virgules, tous exigés (ET) ;
            -- un mot-clé peut compter plusieurs mots
            keywords                    varchar2(4000 char),
            -- commune : codes INSEE
            commune_codes               apex_t_varchar2,
            -- distance : rayon autour des communes, en km ; exige des communes
            distance_km                 number,
            -- departement
            department_codes            apex_t_varchar2,
            -- inclureLimitrophes : true exige des départements ; false et null
            -- ne sont pas envoyés (false est la valeur par défaut de l'API)
            include_bordering           boolean,
            region_code                 ft_regions.region_code%type,
            -- paysContinent : code d'un pays ou d'un continent
            country_continent_code      ft_countries.country_code%type,
            -- typeContrat : un ou plusieurs types, l'un ou l'autre (OU)
            contract_type_codes         apex_t_varchar2,
            -- tempsPlein : true temps plein, false temps partiel, null les deux
            is_full_time                boolean,
            experience_code             ft_experiences.experience_code%type,
            experience_requirement_code ft_experience_requirements.experience_requirement_code%type,
            -- salaireMin et periodeSalaire : l'un exige l'autre
            min_salary                  number,
            salary_period_code          ft_salary_periods.salary_period_code%type,
            -- publieeDepuis : jours depuis la publication, code de ft_posting_periods
            posting_period_code         ft_posting_periods.posting_period_code%type,
            -- offresManqueCandidats : true, false, ou null pour toutes
            is_lacking_candidates       boolean,
            offer_origin_code           ft_offer_origins.offer_origin_code%type
    );

    /**
     * Paramètres de l'appel de recherche, après contrôle des filtres.
     * Mots-clés et listes de codes débarrassés des espaces de début et de fin
     * et de leurs éléments vides (l'API refuse un mot-clé vide), puis joints
     * par des virgules (forme attendue par l'API) ; filtres absents omis.
     * @param in_filters filtres saisis
     * @return objet JSON {"motsCles": ...} pour france_travail_api.call
     *         (http_util.build_url) ; objet vide sans aucun filtre
     * @throws app_errors.co_invalid_input filtre sans le filtre dont il
     *         dépend ; le message nomme le filtre
     */
    function build_params (
        in_filters in t_filters_type
    ) return json;

    -- Collection APEX des résultats de la dernière recherche de la session :
    -- c001 identifiant de l'offre (external_id), clob001 offre en JSON brut
    co_collection_name constant varchar2(30 char) := 'FT_OFFER_SEARCH';

    -- Statuts d'une recherche (t_search_result_type.status)
    -- Toutes les offres sont chargées (aucune offre compris)
    co_status_complete constant varchar2(10 char) := 'COMPLETE';
    -- Chargement arrêté au plafond du package : total > offres chargées
    co_status_capped constant varchar2(10 char) := 'CAPPED';
    -- Échec d'une page après la première : offres déjà reçues conservées
    co_status_partial constant varchar2(10 char) := 'PARTIAL';

    /** Résultat d'une recherche, rendu à l'appelant (page APEX). */
    type t_search_result_type is record (
            -- Nombre d'offres trouvées par l'API, 0 si aucune
            total_count    pls_integer,
            -- Nombre d'offres chargées dans la collection
            loaded_count   pls_integer,
            -- co_status_
            status         varchar2(10 char),
            -- Motif technique d'un échec partiel, null sinon
            failure_reason varchar2(4000 char)
    );

    /**
     * Recherche d'offres : une fois la première page reçue, vide la
     * collection co_collection_name, puis y charge les résultats page par
     * page, jusqu'au total de la recherche ou au plafond du package. Une
     * recherche refusée ou en échec dès la première page laisse la
     * collection intacte. Les pages partagent un correlation_id dans le
     * journal des échanges. Exige une session APEX. Aucun COMMIT.
     * @param in_filters filtres saisis, voir build_params
     * @return total, nombre chargé et statut ; une recherche sans résultat
     *         rend un total de 0, au statut co_status_complete
     * @throws app_errors.co_invalid_input filtre incohérent (build_params),
     *         ou recherche refusée par l'API (400) : le message relaie le
     *         motif de l'API
     * @throws app_errors.co_http_error échec de la première page
     * @throws app_errors.co_invalid_response total illisible (Content-Range)
     */
    function search (
        in_filters in t_filters_type
    ) return t_search_result_type;

    /**
     * Filtres d'une recherche saisis dans une page APEX, en record. Tous
     * facultatifs : null pour un filtre absent. Les filtres que la page
     * n'expose pas (continent, temps plein) restent nuls.
     * @param in_commune_codes        codes séparés par ':' (séparateur des
     *        items multivalués d'APEX), de même pour in_department_codes
     *        et in_contract_type_codes
     * @param in_country_code         rendu dans country_continent_code
     * @param in_is_lacking_candidates 'TRUE', 'FALSE' ou null : une Select
     *        List APEX ne prend pas le type BOOLEAN (constaté en APEX 26.1)
     * @return filtres pour build_params et search
     * @throws app_errors.co_invalid_input in_is_lacking_candidates hors de
     *         'TRUE', 'FALSE' et null
     */
    function to_filters (
        in_keywords                    in varchar2 default null,
        in_commune_codes               in varchar2 default null,
        in_distance_km                 in number default null,
        in_department_codes            in varchar2 default null,
        in_include_bordering           in boolean default null,
        in_region_code                 in varchar2 default null,
        in_country_code                in varchar2 default null,
        in_contract_type_codes         in varchar2 default null,
        in_experience_code             in varchar2 default null,
        in_experience_requirement_code in varchar2 default null,
        in_min_salary                  in number default null,
        in_salary_period_code          in varchar2 default null,
        in_posting_period_code         in varchar2 default null,
        in_is_lacking_candidates       in varchar2 default null,
        in_offer_origin_code           in varchar2 default null
    ) return t_filters_type;

    /**
     * Recherche lancée depuis une page APEX : search(to_filters(...)), le
     * résultat rendu en paramètres OUT, liés directement aux items de la
     * page par un seul appel.
     * @param in_keywords voir to_filters, de même pour les autres in_
     * @param out_status  co_status_
     * @param out_failure_reason motif technique d'un échec partiel, null
     *        sinon
     * @throws app_errors.co_invalid_input voir to_filters et search ;
     *         autres erreurs : voir search
     */
    procedure search (
        in_keywords                    in varchar2 default null,
        in_commune_codes               in varchar2 default null,
        in_distance_km                 in number default null,
        in_department_codes            in varchar2 default null,
        in_include_bordering           in boolean default null,
        in_region_code                 in varchar2 default null,
        in_country_code                in varchar2 default null,
        in_contract_type_codes         in varchar2 default null,
        in_experience_code             in varchar2 default null,
        in_experience_requirement_code in varchar2 default null,
        in_min_salary                  in number default null,
        in_salary_period_code          in varchar2 default null,
        in_posting_period_code         in varchar2 default null,
        in_is_lacking_candidates       in varchar2 default null,
        in_offer_origin_code           in varchar2 default null,
        out_total_count                out pls_integer,
        out_loaded_count               out pls_integer,
        out_status                     out varchar2,
        out_failure_reason             out varchar2
    );

    /**
     * Total d'une recherche, lu dans l'en-tête Content-Range d'une réponse
     * partielle (206) : "offres 0-149/1234" donne 1234.
     * @return null si l'en-tête est absent ou illisible
     */
    function parse_total (
        in_content_range in varchar2
    ) return pls_integer;

    /**
     * Ajoute à la collection co_collection_name les offres d'une page de
     * résultats ({"resultats": [...]}), sans la vider. Exige une session
     * APEX et une collection existante.
     * @param in_response corps de la réponse de l'API
     * @return nombre d'offres ajoutées, 0 si in_response est null ou sans
     *         offre
     */
    function load_offers (
        in_response in clob
    ) return pls_integer;

end ft_offer_search;
/


-- sqlcl_snapshot {"hash":"2d8fb607b9ded6886fd0969fe9825d449be87f9f","type":"PACKAGE_SPEC","name":"FT_OFFER_SEARCH","schemaName":"JOBTRACKER","sxml":""}
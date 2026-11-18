-- liquibase formatted sql
-- changeset JOBTRACKER:1794994602418 stripComments:false  logicalFilePath:feat/offer-search-filters/jobtracker/package_specs/ft_offer_search.sql
-- sqlcl_snapshot src/database/jobtracker/package_specs/ft_offer_search.sql:null:fb807caba9e2e4c786f5d79c26e37ce699436bec:create

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

end ft_offer_search;
/


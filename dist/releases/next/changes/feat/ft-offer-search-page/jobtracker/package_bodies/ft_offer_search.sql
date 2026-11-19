-- liquibase formatted sql
-- changeset JOBTRACKER:1795084539964 stripComments:false  logicalFilePath:feat/ft-offer-search-page/jobtracker/package_bodies/ft_offer_search.sql
-- sqlcl_snapshot src/database/jobtracker/package_bodies/ft_offer_search.sql:ffccf075daffa2f1778b0e79686f197ec2a9cf80:afa119856191db9a37dd9ab2cbec4cf89d30d4d0:alter

create or replace package body jobtracker.ft_offer_search is

    co_scope_prefix            constant varchar2(31 char) := lower($$plsql_unit)
                                                  || '.';
    -- Offres par page : maximum accepté par l'API (en-tête Accept-Range)
    co_page_size               constant pls_integer := 150;
    -- Offres chargées au plus par recherche, pour borner l'attente de
    -- l'utilisateur ; au plus 3150, limite de l'API (range 3000-3149).
    -- Provisoire : à ajuster d'après la durée mesurée d'une page.
    co_max_offers              constant pls_integer := 450;
    -- Essais par page : l'utilisateur attend la réponse
    co_max_attempts            constant pls_integer := 2;
    co_message_rejected        constant app_messages.message_key%type := 'OFFER_SEARCH_REJECTED';
    co_message_invalid_boolean constant app_messages.message_key%type := 'OFFER_SEARCH_INVALID_BOOLEAN';

    /**
     * Éléments non vides d'une liste, sans leurs espaces de début et de fin.
     * La liste reçue est dense (apex_string.split, item APEX multivalué).
     * @return liste vide si in_values est null
     */
    function clean_values (
        in_values in apex_t_varchar2
    ) return apex_t_varchar2 is
        l_values apex_t_varchar2 := apex_t_varchar2();
    begin
        if in_values is not null then
            << input_values >> for i in 1..in_values.count loop
                if trim(in_values(i)) is not null then
                    l_values.extend;
                    l_values(l_values.count) := trim(in_values(i));
                end if;
            end loop input_values;
        end if;

        return l_values;
    end clean_values;

    /**
     * Refuse un filtre sans le filtre dont il dépend : l'API l'ignorerait
     * sans rien dire, et la recherche rendrait plus d'offres qu'attendu.
     * @param in_communes    communes, nettoyées par clean_values
     * @param in_departments départements, nettoyés par clean_values
     * @throws app_errors.co_invalid_input
     */
    procedure check_dependencies (
        in_filters     in t_filters_type,
        in_communes    in apex_t_varchar2,
        in_departments in apex_t_varchar2
    ) is
    begin
        if
            in_filters.distance_km is not null
            and in_communes.count = 0
        then
            app_message.raise_error(app_errors.co_invalid_input, 'OFFER_SEARCH_DISTANCE_WITHOUT_COMMUNE');
        end if;

        if
            in_filters.include_bordering
            and in_departments.count = 0
        then
            app_message.raise_error(app_errors.co_invalid_input, 'OFFER_SEARCH_BORDERING_WITHOUT_DEPARTMENT');
        end if;

        if
            in_filters.min_salary is not null
            and in_filters.salary_period_code is null
        then
            app_message.raise_error(app_errors.co_invalid_input, 'OFFER_SEARCH_SALARY_WITHOUT_PERIOD');
        end if;

        if
            in_filters.min_salary is null
            and in_filters.salary_period_code is not null
        then
            app_message.raise_error(app_errors.co_invalid_input, 'OFFER_SEARCH_PERIOD_WITHOUT_SALARY');
        end if;

    end check_dependencies;

    /** Ajoute une liste jointe par des virgules, si elle n'est pas vide. */
    procedure put_if_set (
        io_params in out nocopy json_object_t,
        in_name   in varchar2,
        in_values in apex_t_varchar2
    ) is
    begin
        if in_values.count > 0 then
            io_params.put(in_name,
                          apex_string.join(in_values, ','));
        end if;
    end put_if_set;

    /** Ajoute une valeur texte, si elle est renseignée. */
    procedure put_if_set (
        io_params in out nocopy json_object_t,
        in_name   in varchar2,
        in_value  in varchar2
    ) is
    begin
        if in_value is not null then
            io_params.put(in_name, in_value);
        end if;
    end put_if_set;

    /** Ajoute une valeur numérique, si elle est renseignée. */
    procedure put_if_set (
        io_params in out nocopy json_object_t,
        in_name   in varchar2,
        in_value  in number
    ) is
    begin
        if in_value is not null then
            io_params.put(in_name, in_value);
        end if;
    end put_if_set;

    /** Ajoute une valeur booléenne, si elle est renseignée. */
    procedure put_if_set (
        io_params in out nocopy json_object_t,
        in_name   in varchar2,
        in_value  in boolean
    ) is
    begin
        if in_value is not null then
            io_params.put(in_name, in_value);
        end if;
    end put_if_set;

    function build_params (
        in_filters in t_filters_type
    ) return json is

        l_keywords       apex_t_varchar2 := clean_values(apex_string.split(in_filters.keywords, ','));
        l_communes       apex_t_varchar2 := clean_values(in_filters.commune_codes);
        l_departments    apex_t_varchar2 := clean_values(in_filters.department_codes);
        l_contract_types apex_t_varchar2 := clean_values(in_filters.contract_type_codes);
        l_params         json_object_t := json_object_t();
    begin
        check_dependencies(in_filters, l_communes, l_departments);
        put_if_set(l_params, 'motsCles', l_keywords);
        put_if_set(l_params, 'commune', l_communes);
        put_if_set(l_params, 'distance', in_filters.distance_km);
        put_if_set(l_params, 'departement', l_departments);
        -- false est la valeur par défaut de l'API : envoyée, elle exigerait
        -- des départements sans rien changer au résultat
        if in_filters.include_bordering then
            l_params.put('inclureLimitrophes', true);
        end if;
        put_if_set(l_params, 'region', in_filters.region_code);
        put_if_set(l_params, 'paysContinent', in_filters.country_continent_code);
        put_if_set(l_params, 'typeContrat', l_contract_types);
        put_if_set(l_params, 'tempsPlein', in_filters.is_full_time);
        put_if_set(l_params, 'experience', in_filters.experience_code);
        put_if_set(l_params, 'experienceExigence', in_filters.experience_requirement_code);
        put_if_set(l_params, 'salaireMin', in_filters.min_salary);
        put_if_set(l_params, 'periodeSalaire', in_filters.salary_period_code);
        put_if_set(l_params, 'publieeDepuis', in_filters.posting_period_code);
        put_if_set(l_params, 'offresManqueCandidats', in_filters.is_lacking_candidates);
        put_if_set(l_params, 'origineOffre', in_filters.offer_origin_code);
        return l_params.to_json;
    end build_params;

    function parse_total (
        in_content_range in varchar2
    ) return pls_integer is
    begin
        return to_number ( regexp_substr(in_content_range, '/(\d+)$', 1, 1, null,
                                         1) );
    end parse_total;

    function load_offers (
        in_response in clob
    ) return pls_integer is
        l_count pls_integer := 0;
    begin
        -- error on error : un corps illisible sur une réponse 2xx est une
        -- anomalie de l'API, pas une recherche sans résultat
        << offers >> for r_offer in (
            select
                jt.external_id,
                jt.offer
            from
                    json_table ( in_response, '$.resultats[*]' error on error
                        columns (
                            external_id varchar2 ( 100 char ) path '$.id',
                            offer clob format json path '$'
                        )
                    )
                jt
        ) loop
            apex_collection.add_member(
                p_collection_name => co_collection_name,
                p_c001            => r_offer.external_id,
                p_clob001         => r_offer.offer
            );

            l_count := l_count + 1;
        end loop offers;

        return l_count;
    end load_offers;

    /**
     * Une page de résultats, avec un nombre d'essais réduit. Le code de
     * statut et les en-têtes de la réponse restent lisibles après l'appel.
     * @param in_params paramètres de la recherche (build_params), sans range
     * @param in_offset index de la première offre de la page, à partir de 0
     * @return corps de la réponse, null sur une 204
     * @throws app_errors.co_http_error voir france_travail_api.call
     */
    function fetch_page (
        in_params         in json_object_t,
        in_offset         in pls_integer,
        in_correlation_id in raw
    ) return clob is
        l_params json_object_t := in_params.clone;
    begin
        l_params.put('range',
                     in_offset
                     || '-'
                     ||(least(in_offset + co_page_size, co_max_offers) - 1));

        return france_travail_api.call(
            in_endpoint       => france_travail_api.co_endpoint_offer_search,
            in_params         => l_params.to_json,
            in_correlation_id => in_correlation_id,
            in_max_attempts   => co_max_attempts
        );

    end fetch_page;

    function search (
        in_filters in t_filters_type
    ) return t_search_result_type is

        l_scope          logger_logs.scope%type := co_scope_prefix || 'search';
        -- Contrôle des filtres avant de vider les résultats précédents
        l_params         json_object_t := json_object_t(build_params(in_filters));
        -- Regroupe dans le journal des échanges les pages de la recherche
        l_correlation_id raw(16) := exchange_log.new_correlation_id;
        l_offset         pls_integer := 0;
        l_body           clob;
        l_result         t_search_result_type;
    begin
        -- Première page : un échec est remonté à l'utilisateur, avec les
        -- résultats de la recherche précédente
        begin
            l_body := fetch_page(l_params, l_offset, l_correlation_id);
        exception
            when app_errors.e_http_error then
                -- Limite de l'API (nombre de mots-clés, format...) : seul retour
                -- à l'utilisateur sur ce que build_params ne contrôle pas
                if apex_web_service.g_status_code = utl_http.http_bad_request then
                    app_message.raise_error(app_errors.co_invalid_input, co_message_rejected, france_travail_api.last_error_message);
                end if;

                raise;
        end;

        apex_collection.create_or_truncate_collection(co_collection_name);
        l_result.loaded_count := load_offers(l_body);
        l_result.total_count :=
            case apex_web_service.g_status_code
                -- Aucune offre
                when utl_http.http_no_content      then
                    0
                -- Une partie des offres : total dans Content-Range
                when utl_http.http_partial_content then
                    parse_total(http_util.response_header(http_util.co_header_content_range))
                -- Toutes les offres tiennent dans la page
                else
                    l_result.loaded_count
            end;

        if l_result.total_count is null then
            raise_application_error(app_errors.co_invalid_response,
                                    'Missing or unreadable Content-Range header: '
                                    || http_util.response_header(http_util.co_header_content_range));
        end if;

        -- Pages suivantes : un échec garde les offres déjà chargées
        << pages >> loop
            l_offset := l_offset + co_page_size;
            exit pages when l_offset >= least(l_result.total_count, co_max_offers);
            begin
                l_body := fetch_page(l_params, l_offset, l_correlation_id);
            exception
                when app_errors.e_http_error then
                    logger.log_error('Offer search stopped at offset '
                                     || l_offset
                                     || ': '
                                     || sqlerrm, l_scope);
                    l_result.status := co_status_partial;
                    l_result.failure_reason := sqlerrm;
                    exit pages;
            end;

            l_result.loaded_count := l_result.loaded_count + load_offers(l_body);
        end loop pages;

        l_result.status := coalesce(l_result.status,
                                    case
                                        when l_result.total_count > co_max_offers then
                                            co_status_capped
                                        else
                                            co_status_complete
                                    end
        );

        return l_result;
    end search;

    /**
     * Liste de codes d'un item APEX multivalué.
     * @return null si in_values est null (filtre absent)
     */
    function split_codes (
        in_values in varchar2
    ) return apex_t_varchar2 is
    begin
        return
            case
                when in_values is not null then
                    apex_string.split(in_values, ':')
            end;
    end split_codes;

    /**
     * Booléen à trois états reçu d'une Select List APEX.
     * @return null si in_value est null (filtre absent)
     * @throws app_errors.co_invalid_input valeur hors de 'TRUE' et 'FALSE'
     */
    function to_boolean (
        in_value in varchar2
    ) return boolean is
    begin
        if in_value is null then
            return null;
        elsif in_value = 'TRUE' then
            return true;
        elsif in_value = 'FALSE' then
            return false;
        end if;

        app_message.raise_error(app_errors.co_invalid_input, co_message_invalid_boolean, in_value);
    end to_boolean;

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
    ) return t_filters_type is
        l_filters t_filters_type;
    begin
        l_filters.keywords := in_keywords;
        l_filters.commune_codes := split_codes(in_commune_codes);
        l_filters.distance_km := in_distance_km;
        l_filters.department_codes := split_codes(in_department_codes);
        l_filters.include_bordering := in_include_bordering;
        l_filters.region_code := in_region_code;
        l_filters.country_continent_code := in_country_code;
        l_filters.contract_type_codes := split_codes(in_contract_type_codes);
        l_filters.experience_code := in_experience_code;
        l_filters.experience_requirement_code := in_experience_requirement_code;
        l_filters.min_salary := in_min_salary;
        l_filters.salary_period_code := in_salary_period_code;
        l_filters.posting_period_code := in_posting_period_code;
        l_filters.is_lacking_candidates := to_boolean ( in_is_lacking_candidates );
        l_filters.offer_origin_code := in_offer_origin_code;
        return l_filters;
    end to_filters;

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
    ) is
        l_result t_search_result_type;
    begin
        l_result := search(to_filters(
            in_keywords                    => in_keywords,
            in_commune_codes               => in_commune_codes,
            in_distance_km                 => in_distance_km,
            in_department_codes            => in_department_codes,
            in_include_bordering           => in_include_bordering,
            in_region_code                 => in_region_code,
            in_country_code                => in_country_code,
            in_contract_type_codes         => in_contract_type_codes,
            in_experience_code             => in_experience_code,
            in_experience_requirement_code => in_experience_requirement_code,
            in_min_salary                  => in_min_salary,
            in_salary_period_code          => in_salary_period_code,
            in_posting_period_code         => in_posting_period_code,
            in_is_lacking_candidates       => in_is_lacking_candidates,
            in_offer_origin_code           => in_offer_origin_code
        ));

        out_total_count := l_result.total_count;
        out_loaded_count := l_result.loaded_count;
        out_status := l_result.status;
        out_failure_reason := l_result.failure_reason;
    end search;

end ft_offer_search;
/


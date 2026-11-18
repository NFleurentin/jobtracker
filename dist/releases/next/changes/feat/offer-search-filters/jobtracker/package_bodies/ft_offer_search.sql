-- liquibase formatted sql
-- changeset JOBTRACKER:1794994602470 stripComments:false  logicalFilePath:feat/offer-search-filters/jobtracker/package_bodies/ft_offer_search.sql
-- sqlcl_snapshot src/database/jobtracker/package_bodies/ft_offer_search.sql:null:3265acbde304ded688d2e3dd744efb93a9e2efa3:create

create or replace package body jobtracker.ft_offer_search is

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

end ft_offer_search;
/


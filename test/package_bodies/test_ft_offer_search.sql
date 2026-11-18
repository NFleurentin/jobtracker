create or replace package body jobtracker.test_ft_offer_search is

    /** Paramètres produits par build_params, en objet manipulable. */
    function params (
        in_filters in ft_offer_search.t_filters_type
    ) return json_object_t is
    begin
        return json_object_t(ft_offer_search.build_params(in_filters));
    end params;

    procedure no_filter_empty is
        l_filters ft_offer_search.t_filters_type;
    begin
        ut.expect(params(l_filters).get_size).to_equal(0);
    end no_filter_empty;

    procedure all_filters_mapped is
        l_filters ft_offer_search.t_filters_type;
        l_params  json_object_t;
    begin
        -- Lieu par commune
        l_filters.keywords := 'sql';
        l_filters.commune_codes := apex_t_varchar2('75056');
        l_filters.distance_km := 20;
        l_filters.contract_type_codes := apex_t_varchar2('CDI');
        l_filters.is_full_time := true;
        l_filters.experience_code := '1';
        l_filters.experience_requirement_code := 'D';
        l_filters.min_salary := 1500.5;
        l_filters.salary_period_code := 'M';
        l_filters.posting_period_code := '7';
        l_filters.is_lacking_candidates := true;
        l_filters.offer_origin_code := '2';
        l_params := params(l_filters);
        ut.expect(l_params.get_string('motsCles')).to_equal('sql');
        ut.expect(l_params.get_string('commune')).to_equal('75056');
        ut.expect(l_params.get_number('distance')).to_equal(20);
        ut.expect(l_params.get_string('typeContrat')).to_equal('CDI');
        ut.expect(l_params.get_boolean('tempsPlein')).to_be_true;
        ut.expect(l_params.get_string('experience')).to_equal('1');
        ut.expect(l_params.get_string('experienceExigence')).to_equal('D');
        ut.expect(l_params.get_number('salaireMin')).to_equal(1500.5);

        ut.expect(l_params.get_string('periodeSalaire')).to_equal('M');
        ut.expect(l_params.get_string('publieeDepuis')).to_equal('7');
        ut.expect(l_params.get_boolean('offresManqueCandidats')).to_be_true;
        ut.expect(l_params.get_string('origineOffre')).to_equal('2');
        ut.expect(l_params.get_size).to_equal(12);

        -- Autres critères de lieu, un seul à la fois
        l_filters := null;
        l_filters.department_codes := apex_t_varchar2('75');
        l_filters.include_bordering := true;
        l_params := params(l_filters);
        ut.expect(l_params.get_string('departement')).to_equal('75');
        ut.expect(l_params.get_boolean('inclureLimitrophes')).to_be_true;
        l_filters := null;
        l_filters.region_code := '84';
        ut.expect(params(l_filters).get_string('region')).to_equal('84');

        l_filters := null;
        l_filters.country_continent_code := '01';
        ut.expect(params(l_filters).get_string('paysContinent')).to_equal('01');

    end all_filters_mapped;

    procedure lists_cleaned_and_joined is
        l_filters ft_offer_search.t_filters_type;
        l_params  json_object_t;
    begin
        l_filters.keywords := ' data , ,sql ,';
        l_filters.department_codes := apex_t_varchar2(' 75', null, '92 ');
        l_filters.contract_type_codes := apex_t_varchar2('CDI', ' ', 'CDD');
        l_params := params(l_filters);
        ut.expect(l_params.get_string('motsCles')).to_equal('data,sql');
        ut.expect(l_params.get_string('departement')).to_equal('75,92');
        ut.expect(l_params.get_string('typeContrat')).to_equal('CDI,CDD');
    end lists_cleaned_and_joined;

    procedure keyword_with_spaces is
        l_filters ft_offer_search.t_filters_type;
    begin
        l_filters.keywords := 'data engineer,pl sql';
        ut.expect(params(l_filters).get_string('motsCles')).to_equal('data engineer,pl sql');

    end keyword_with_spaces;

    procedure false_booleans is
        l_filters ft_offer_search.t_filters_type;
        l_params  json_object_t;
    begin
        l_filters.is_full_time := false;
        l_filters.is_lacking_candidates := false;
        l_filters.include_bordering := false;
        l_params := params(l_filters);
        ut.expect(l_params.get_boolean('tempsPlein')).to_be_false;
        ut.expect(l_params.get_boolean('offresManqueCandidats')).to_be_false;
        ut.expect(l_params.has('inclureLimitrophes')).to_be_false;
    end false_booleans;

    procedure api_limits_not_checked is
        l_filters ft_offer_search.t_filters_type;
        l_params  json_object_t;
    begin
        -- Refusés par l'API (erreur 400), pas par le package
        l_filters.keywords := 'k1,k2,k3,k4,k5,k6,k7,a';
        l_filters.commune_codes := apex_t_varchar2('C1', 'C2', 'C3', 'C4', 'C5',
                                                   'C6');

        l_filters.region_code := '84';
        l_filters.posting_period_code := '30';
        l_params := params(l_filters);
        ut.expect(l_params.get_string('motsCles')).to_equal('k1,k2,k3,k4,k5,k6,k7,a');
        ut.expect(l_params.get_string('commune')).to_equal('C1,C2,C3,C4,C5,C6');
        ut.expect(l_params.get_string('region')).to_equal('84');
        ut.expect(l_params.get_string('publieeDepuis')).to_equal('30');
    end api_limits_not_checked;

    procedure distance_without_commune is
        l_filters ft_offer_search.t_filters_type;
    begin
        l_filters.department_codes := apex_t_varchar2('75');
        l_filters.distance_km := 10;
        ut.expect(params(l_filters).get_size).to_equal(0);
    end distance_without_commune;

    procedure bordering_without_department is
        l_filters ft_offer_search.t_filters_type;
    begin
        l_filters.region_code := '84';
        l_filters.include_bordering := true;
        ut.expect(params(l_filters).get_size).to_equal(0);
    end bordering_without_department;

    procedure salary_without_period is
        l_filters ft_offer_search.t_filters_type;
    begin
        l_filters.min_salary := 30000;
        ut.expect(params(l_filters).get_size).to_equal(0);
    end salary_without_period;

    procedure period_without_salary is
        l_filters ft_offer_search.t_filters_type;
    begin
        l_filters.salary_period_code := 'A';
        ut.expect(params(l_filters).get_size).to_equal(0);
    end period_without_salary;

    procedure messages_in_catalog is

        type t_keys_type is
            table of app_messages.message_key%type;
        l_keys t_keys_type := t_keys_type('OFFER_SEARCH_DISTANCE_WITHOUT_COMMUNE', 'OFFER_SEARCH_BORDERING_WITHOUT_DEPARTMENT', 'OFFER_SEARCH_SALARY_WITHOUT_PERIOD'
        , 'OFFER_SEARCH_PERIOD_WITHOUT_SALARY');
    begin
        << message_keys >> for i in 1..l_keys.count loop
            ut.expect(
                app_message.has_message(l_keys(i)),
                l_keys(i)
            ).to_be_true;
        end loop message_keys;
    end messages_in_catalog;

end test_ft_offer_search;
/

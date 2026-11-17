create or replace package body jobtracker.test_ft_referential_loader is

    /** Ouvre un chargement et rend son identifiant. */
    function new_load return ft_referential_loads.ft_referential_load_id%type is
        l_load_id ft_referential_loads.ft_referential_load_id%type;
    begin
        insert into ft_referential_loads ( started_at ) values
            ( systimestamp )
        returning ft_referential_load_id into l_load_id;

        return l_load_id;
    end new_load;

    /** Charge une fixture de régions dans un nouveau chargement. */
    function load_regions (
        in_response in clob
    ) return json_object_t is
    begin
        return ft_referential_loader.load_response(ft_referential_loader.co_referential_regions, new_load, in_response);
    end load_regions;

    /** Chargement porté par une région. */
    function region_load_id (
        in_code in ft_regions.region_code%type
    ) return ft_regions.ft_referential_load_id%type is
        l_load_id ft_regions.ft_referential_load_id%type;
    begin
        select
            ft_referential_load_id
        into l_load_id
        from
            ft_regions
        where
            region_code = in_code;

        return l_load_id;
    end region_load_id;

    procedure codes_inserted is
        l_load_id ft_referential_loads.ft_referential_load_id%type := new_load;
        l_result  json_object_t;
        l_name    ft_regions.region_name%type;
    begin
        l_result := ft_referential_loader.load_response(ft_referential_loader.co_referential_regions, l_load_id, '[{"code":"T1","libelle":"Région 1"},{"code":"T2","libelle":"Région 2"}]'
        );
        ut.expect(l_result.get_number('received')).to_equal(2);
        ut.expect(region_load_id('T1')).to_equal(l_load_id);
        select
            region_name
        into l_name
        from
            ft_regions
        where
            region_code = 'T2';

        ut.expect(l_name).to_equal('Région 2');
    end codes_inserted;

    procedure code_updated is
        l_result json_object_t;
        l_name   ft_regions.region_name%type;
    begin
        l_result := load_regions('[{"code":"T1","libelle":"Ancien libellé"}]');
        l_result := load_regions('[{"code":"T1","libelle":"Nouveau libellé"}]');
        select
            region_name
        into l_name
        from
            ft_regions
        where
            region_code = 'T1';

        ut.expect(l_name).to_equal('Nouveau libellé');
        ut.expect(l_result.get_number('no_longer_current')).to_equal(0);
    end code_updated;

    procedure missing_codes_counted is
        l_result json_object_t;
    begin
        l_result := load_regions('[{"code":"T1","libelle":"Région 1"},{"code":"T2","libelle":"Région 2"},{"code":"T3","libelle":"Région 3"}]'
        );
        l_result := load_regions('[{"code":"T1","libelle":"Région 1"}]');
        ut.expect(l_result.get_number('received')).to_equal(1);
        ut.expect(l_result.get_number('no_longer_current')).to_equal(2);
    end missing_codes_counted;

    procedure reappeared_code_current is
        l_result     json_object_t;
        l_is_current boolean;
    begin
        l_result := load_regions('[{"code":"T1","libelle":"Région 1"},{"code":"T2","libelle":"Région 2"}]');
        l_result := load_regions('[{"code":"T1","libelle":"Région 1"}]');
        l_result := load_regions('[{"code":"T1","libelle":"Région 1"},{"code":"T2","libelle":"Région 2"}]');
        select
            is_current
        into l_is_current
        from
            ft_region_details
        where
            region_code = 'T2';

        ut.expect(l_is_current).to_be_true;
    end reappeared_code_current;

    procedure independent_referentials_loaded is
        l_load_id ft_referential_loads.ft_referential_load_id%type := new_load;
        l_result  json_object_t;
        l_count   pls_integer;
    begin
        l_result := ft_referential_loader.load_response(ft_referential_loader.co_referential_countries, l_load_id, '[{"code":"T1","libelle":"Pays 1"}]'
        );
        l_result := ft_referential_loader.load_response(ft_referential_loader.co_referential_continents, l_load_id, '[{"code":"T1","libelle":"Continent 1"}]'
        );
        l_result := ft_referential_loader.load_response(ft_referential_loader.co_referential_contract_types, l_load_id, '[{"code":"T1","libelle":"Contrat 1"}]'
        );
        select
            (
                select
                    count(*)
                from
                    ft_countries
                where
                        country_code = 'T1'
                    and ft_referential_load_id = l_load_id
            ) + (
                select
                    count(*)
                from
                    ft_continents
                where
                        continent_code = 'T1'
                    and ft_referential_load_id = l_load_id
            ) + (
                select
                    count(*)
                from
                    ft_contract_types
                where
                        contract_type_code = 'T1'
                    and ft_referential_load_id = l_load_id
            )
        into l_count
        from
            dual;

        ut.expect(l_count).to_equal(3);
    end independent_referentials_loaded;

    procedure department_region_set is
        l_result      json_object_t;
        l_region_code ft_departments.region_code%type;
    begin
        l_result := load_regions('[{"code":"T1","libelle":"Région 1"}]');
        l_result := ft_referential_loader.load_response(ft_referential_loader.co_referential_departments, new_load, '[{"code":"T1","libelle":"Département 1","region":{"code":"T1","libelle":"Région 1"}}]'
        );
        select
            region_code
        into l_region_code
        from
            ft_departments
        where
            department_code = 'T1';

        ut.expect(l_region_code).to_equal('T1');
        ut.expect(l_result.get_array('anomalies').get_size).to_equal(0);

    end department_region_set;

    procedure department_unknown_region is
        l_result      json_object_t;
        l_anomaly     json_object_t;
        l_region_code ft_departments.region_code%type;
    begin
        l_result := ft_referential_loader.load_response(ft_referential_loader.co_referential_departments, new_load, '[{"code":"T1","libelle":"Département 1","region":{"code":"TX"}},' || '{"code":"T2","libelle":"Département 2","region":{"code":"TX"}}]'
        );

        select
            region_code
        into l_region_code
        from
            ft_departments
        where
            department_code = 'T1';

        ut.expect(l_region_code).to_be_null;
        ut.expect(l_result.get_number('received')).to_equal(2);
        ut.expect(l_result.get_array('anomalies').get_size).to_equal(1);

        l_anomaly := treat(l_result.get_array('anomalies').get(0) as json_object_t);

        ut.expect(l_anomaly.get_string('parent_code')).to_equal('TX');
        ut.expect(l_anomaly.get_number('row_count')).to_equal(2);
    end department_unknown_region;

    procedure commune_unknown_department is

        l_load_id         ft_referential_loads.ft_referential_load_id%type := new_load;
        l_result          json_object_t;
        l_anomaly         json_object_t;
        l_department_code ft_communes.department_code%type;
        l_postal_code     ft_communes.postal_code%type;
    begin
        l_result := ft_referential_loader.load_response(ft_referential_loader.co_referential_departments, l_load_id, '[{"code":"T1","libelle":"Département 1"}]'
        );
        l_result := ft_referential_loader.load_response(ft_referential_loader.co_referential_communes, l_load_id, '[{"code":"T1","libelle":"Commune 1","codePostal":"00001","codeDepartement":"T1"},' || '{"code":"T2","libelle":"Commune 2","codeDepartement":"TX"}]'
        );

        select
            department_code,
            postal_code
        into
            l_department_code,
            l_postal_code
        from
            ft_communes
        where
            commune_code = 'T1';

        ut.expect(l_department_code).to_equal('T1');
        ut.expect(l_postal_code).to_equal('00001');
        select
            department_code
        into l_department_code
        from
            ft_communes
        where
            commune_code = 'T2';

        ut.expect(l_department_code).to_be_null;
        ut.expect(l_result.get_array('anomalies').get_size).to_equal(1);

        l_anomaly := treat(l_result.get_array('anomalies').get(0) as json_object_t);

        ut.expect(l_anomaly.get_string('parent_code')).to_equal('TX');
        ut.expect(l_anomaly.get_number('row_count')).to_equal(1);
    end commune_unknown_department;

    procedure empty_array_rejected is
        l_result json_object_t;
    begin
        l_result := load_regions('[]');
    end empty_array_rejected;

    procedure null_response_rejected is
        l_result json_object_t;
    begin
        l_result := load_regions(null);
    end null_response_rejected;

    procedure invalid_json_rejected is
        l_result json_object_t;
    begin
        l_result := load_regions('[{"code":"T1"');
    end invalid_json_rejected;

    procedure object_response_rejected is
        l_result json_object_t;
    begin
        l_result := load_regions('{"code":"T1","libelle":"Région 1"}');
    end object_response_rejected;

    procedure rejected_response_keeps_codes is
        l_result  json_object_t;
        l_load_id ft_referential_loads.ft_referential_load_id%type;
    begin
        l_result := load_regions('[{"code":"T1","libelle":"Région 1"}]');
        l_load_id := region_load_id('T1');
        begin
            l_result := load_regions('[]');
        exception
            when app_errors.e_invalid_response then
                null;
        end;

        ut.expect(region_load_id('T1')).to_equal(l_load_id);
    end rejected_response_keeps_codes;

    procedure unknown_referential_rejected is
        l_result json_object_t;
    begin
        l_result := ft_referential_loader.load_response('UNKNOWN', new_load, '[{"code":"T1","libelle":"X"}]');
    end unknown_referential_rejected;

    procedure no_job_not_running is
    begin
        ut.expect(ft_referential_loader.is_load_running).to_be_false;
        ut.expect(ft_referential_loader.load_state().get_boolean('running')).to_be_false;
    end no_job_not_running;

    procedure latest_load_state is
        l_load_id ft_referential_loads.ft_referential_load_id%type;
        l_state   json_object_t;
    begin
        l_load_id := new_load;
        l_state := ft_referential_loader.load_state;
        ut.expect(l_state.get_number('load_id')).to_equal(l_load_id);
        ut.expect(l_state.get_string('load_state')).to_equal('INTERRUPTED');
        ut.expect(l_state.get_number('error_count')).to_equal(0);
    end latest_load_state;

end test_ft_referential_loader;
/

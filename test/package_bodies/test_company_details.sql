create or replace package body jobtracker.test_company_details is

    /** Ligne de la vue pour l'entreprise donnée. */
    function get_details (
        in_company_id in companies.company_id%type
    ) return company_details%rowtype is
        r_details company_details%rowtype;
    begin
        select
            *
        into r_details
        from
            company_details
        where
            company_id = in_company_id;

        return r_details;
    end get_details;

    /** Lieu de test : locations n'a ni donnée de référence ni package d'écriture. */
    function new_location return locations.location_id%type is
        l_location_type_id location_types.location_type_id%type;
        l_location_id      locations.location_id%type;
    begin
        select
            location_type_id
        into l_location_type_id
        from
            location_types
        order by
            location_type_id
        fetch first 1 row only;

        insert into locations (
            location_type_id,
            location_name
        ) values
            ( l_location_type_id,
              'Lieu test' )
        returning location_id into l_location_id;

        return l_location_id;
    end new_location;

    procedure company_without_references is
        r_details company_details%rowtype;
    begin
        r_details := get_details(company_api.create_company('Acme'));
        ut.expect(r_details.company_name).to_equal('Acme');
        ut.expect(r_details.parent_company_name).to_be_null();
        ut.expect(r_details.company_type_name).to_be_null();
        ut.expect(r_details.sector_name).to_be_null();
        ut.expect(r_details.company_size_short_name).to_be_null();
        ut.expect(r_details.company_size_long_name).to_be_null();
        ut.expect(r_details.location_name).to_be_null();
    end company_without_references;

    procedure company_with_all_references is

        r_type      company_types%rowtype;
        r_sector    sectors%rowtype;
        r_size      company_sizes%rowtype;
        l_parent_id companies.company_id%type;
        r_details   company_details%rowtype;
    begin
        select
            *
        into r_type
        from
            company_types
        order by
            company_type_id
        fetch first 1 row only;

        select
            *
        into r_sector
        from
            sectors
        order by
            sector_id
        fetch first 1 row only;

        select
            *
        into r_size
        from
            company_sizes
        order by
            company_size_id
        fetch first 1 row only;

        l_parent_id := company_api.create_company('Groupe');
        r_details := get_details(company_api.create_company(
            in_company_name      => 'Filiale',
            in_parent_company_id => l_parent_id,
            in_company_type_id   => r_type.company_type_id,
            in_sector_id         => r_sector.sector_id,
            in_company_size_id   => r_size.company_size_id,
            in_location_id       => new_location
        ));

        ut.expect(r_details.parent_company_name).to_equal('Groupe');
        ut.expect(r_details.company_type_name).to_equal(r_type.company_type_name_fr);
        ut.expect(r_details.sector_name).to_equal(r_sector.sector_name_fr);
        ut.expect(r_details.company_size_short_name).to_equal(r_size.company_size_short_name_fr);
        ut.expect(r_details.company_size_long_name).to_equal(r_size.company_size_long_name_fr);
        ut.expect(r_details.company_size_display_order).to_equal(r_size.display_order);
        ut.expect(r_details.location_name).to_equal('Lieu test');
    end company_with_all_references;

    procedure one_row_per_company is
        l_parent_id  companies.company_id%type;
        l_company_id companies.company_id%type;
        l_count      pls_integer;
    begin
        -- Deux filiales : une jointure vers les enfants dupliquerait le parent
        l_parent_id := company_api.create_company('Groupe');
        l_company_id := company_api.create_company(
            in_company_name      => 'Filiale 1',
            in_parent_company_id => l_parent_id
        );
        l_company_id := company_api.create_company(
            in_company_name      => 'Filiale 2',
            in_parent_company_id => l_parent_id
        );
        select
            count(*)
        into l_count
        from
            company_details
        where
            company_id = l_parent_id;

        ut.expect(l_count).to_equal(1);
    end one_row_per_company;

    procedure labels_in_english_session is

        r_type    company_types%rowtype;
        r_sector  sectors%rowtype;
        r_size    company_sizes%rowtype;
        r_details company_details%rowtype;
    begin
        select
            *
        into r_type
        from
            company_types
        order by
            company_type_id
        fetch first 1 row only;

        select
            *
        into r_sector
        from
            sectors
        order by
            sector_id
        fetch first 1 row only;

        select
            *
        into r_size
        from
            company_sizes
        order by
            company_size_id
        fetch first 1 row only;

        -- La langue vient de la session APEX (app_message.current_language),
        -- ouverte par test_helpers.start_english_session
        r_details := get_details(company_api.create_company(
            in_company_name    => 'Acme',
            in_company_type_id => r_type.company_type_id,
            in_sector_id       => r_sector.sector_id,
            in_company_size_id => r_size.company_size_id
        ));

        ut.expect(r_details.company_type_name).to_equal(r_type.company_type_name_en);
        ut.expect(r_details.sector_name).to_equal(r_sector.sector_name_en);
        ut.expect(r_details.company_size_short_name).to_equal(r_size.company_size_short_name_en);
        ut.expect(r_details.company_size_long_name).to_equal(r_size.company_size_long_name_en);
    end labels_in_english_session;

end test_company_details;
/

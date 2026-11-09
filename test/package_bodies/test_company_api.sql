create or replace package body jobtracker.test_company_api is

    co_unknown_company_id constant companies.company_id%type := -1;

    /** Entreprise de test, rattachée au parent donné. */
    function new_company (
        in_parent_company_id in companies.parent_company_id%type default null
    ) return companies.company_id%type is
    begin
        return company_api.create_company(
            in_company_name      => 'Test',
            in_parent_company_id => in_parent_company_id
        );
    end new_company;

    /** Poste d'un contact de test dans l'entreprise donnée. */
    procedure add_position (
        in_company_id in companies.company_id%type
    ) is
        l_contact_position_id contact_positions.contact_position_id%type;
    begin
        l_contact_position_id := contact_api.create_position(
            in_contact_id => contact_api.create_contact('Martin'),
            in_company_id => in_company_id,
            in_job_id     => job_api.create_job('Test scout', 'Éclaireur de test'),
            in_is_current => true
        );
    end add_position;

    /** Nombre de postes dans l'entreprise donnée. */
    function count_positions (
        in_company_id in companies.company_id%type
    ) return pls_integer is
        l_count pls_integer;
    begin
        select
            count(*)
        into l_count
        from
            contact_positions
        where
            company_id = in_company_id;

        return l_count;
    end count_positions;

    /** Ligne de l'entreprise donnée. */
    function get_company (
        in_company_id in companies.company_id%type
    ) return companies%rowtype is
        r_company companies%rowtype;
    begin
        select
            *
        into r_company
        from
            companies
        where
            company_id = in_company_id;

        return r_company;
    end get_company;

    /** Identifiant de l'entreprise générique, créée par la migration. */
    function generic_company_id return companies.company_id%type is
        l_company_id companies.company_id%type;
    begin
        select
            company_id
        into l_company_id
        from
            companies
        where
            is_generic = true;

        return l_company_id;
    end generic_company_id;

    /** Change le parent d'une entreprise, les autres colonnes étant vidées. */
    procedure set_parent (
        in_company_id        in companies.company_id%type,
        in_parent_company_id in companies.parent_company_id%type
    ) is
    begin
        company_api.update_company(
            in_company_id        => in_company_id,
            in_company_name      => 'Test',
            in_description       => null,
            in_note_text         => null,
            in_parent_company_id => in_parent_company_id,
            in_company_type_id   => null,
            in_sector_id         => null,
            in_company_size_id   => null,
            in_location_id       => null,
            in_siren             => null,
            in_website_url       => null,
            in_linkedin_slug     => null,
            in_email             => null,
            in_phone             => null,
            in_creation_year     => null
        );
    end set_parent;

    procedure create_company_name_only is
        r_company companies%rowtype;
    begin
        r_company := get_company(company_api.create_company('Acme'));
        ut.expect(r_company.company_name).to_equal('Acme');
        ut.expect(r_company.siren).to_be_null();
        ut.expect(r_company.created_at).to_be_not_null();
        ut.expect(r_company.updated_at).to_be_not_null();
    end create_company_name_only;

    procedure create_company_all_columns is
        l_type_id   company_types.company_type_id%type;
        l_parent_id companies.company_id%type;
        r_company   companies%rowtype;
    begin
        select
            company_type_id
        into l_type_id
        from
            company_types
        where
            company_type_code = 'ESN';

        l_parent_id := new_company;
        r_company := get_company(company_api.create_company(
            in_company_name      => 'Acme',
            in_description       => to_clob('Description'),
            in_note_text         => to_clob('Note'),
            in_parent_company_id => l_parent_id,
            in_company_type_id   => l_type_id,
            in_siren             => '123456789',
            in_website_url       => 'https://example.test',
            in_linkedin_slug     => 'acme',
            in_email             => 'contact@example.test',
            in_phone             => '0102030405',
            in_creation_year     => 2001
        ));

        ut.expect(r_company.description).to_equal(to_clob('Description'));
        ut.expect(r_company.note_text).to_equal(to_clob('Note'));
        ut.expect(r_company.parent_company_id).to_equal(l_parent_id);
        ut.expect(r_company.company_type_id).to_equal(l_type_id);
        ut.expect(r_company.siren).to_equal('123456789');
        ut.expect(r_company.website_url).to_equal('https://example.test');
        ut.expect(r_company.linkedin_slug).to_equal('acme');
        ut.expect(r_company.email).to_equal('contact@example.test');
        ut.expect(r_company.phone).to_equal('0102030405');
        ut.expect(r_company.creation_year).to_equal(2001);
    end create_company_all_columns;

    procedure update_company_replaces_columns is
        l_company_id companies.company_id%type;
        r_company    companies%rowtype;
    begin
        l_company_id := company_api.create_company(
            in_company_name => 'Avant',
            in_siren        => '123456789'
        );
        company_api.update_company(
            in_company_id        => l_company_id,
            in_company_name      => 'Après',
            in_description       => null,
            in_note_text         => to_clob('Note'),
            in_parent_company_id => null,
            in_company_type_id   => null,
            in_sector_id         => null,
            in_company_size_id   => null,
            in_location_id       => null,
            in_siren             => null,
            in_website_url       => null,
            in_linkedin_slug     => null,
            in_email             => null,
            in_phone             => null,
            in_creation_year     => null
        );

        r_company := get_company(l_company_id);
        ut.expect(r_company.company_name).to_equal('Après');
        ut.expect(r_company.note_text).to_equal(to_clob('Note'));
        ut.expect(r_company.siren).to_be_null();
    end update_company_replaces_columns;

    procedure update_company_sets_updated_at is
        l_company_id companies.company_id%type;
        r_before     companies%rowtype;
        r_after      companies%rowtype;
    begin
        l_company_id := new_company;
        update companies
        set
            created_at = systimestamp - interval '1' day,
            updated_at = systimestamp - interval '1' day
        where
            company_id = l_company_id;

        r_before := get_company(l_company_id);
        set_parent(l_company_id, null);
        r_after := get_company(l_company_id);
        ut.expect(r_after.updated_at).to_be_greater_than(r_before.updated_at);
        ut.expect(r_after.created_at).to_equal(r_before.created_at);
    end update_company_sets_updated_at;

    procedure update_company_unknown is
    begin
        set_parent(co_unknown_company_id, null);
    end update_company_unknown;

    procedure update_company_valid_parent is
        l_parent_id  companies.company_id%type;
        l_company_id companies.company_id%type;
    begin
        l_parent_id := new_company;
        l_company_id := new_company;
        set_parent(l_company_id, l_parent_id);
        ut.expect(get_company(l_company_id).parent_company_id).to_equal(l_parent_id);
    end update_company_valid_parent;

    procedure update_company_clears_parent is
        l_company_id companies.company_id%type;
    begin
        l_company_id := new_company(new_company);
        set_parent(l_company_id, null);
        ut.expect(get_company(l_company_id).parent_company_id).to_be_null();
    end update_company_clears_parent;

    procedure update_company_self_parent is
        l_company_id companies.company_id%type;
    begin
        l_company_id := new_company;
        set_parent(l_company_id, l_company_id);
    end update_company_self_parent;

    procedure update_company_direct_cycle is
        l_parent_id companies.company_id%type;
        l_child_id  companies.company_id%type;
    begin
        l_parent_id := new_company;
        l_child_id := new_company(l_parent_id);
        set_parent(l_parent_id, l_child_id);
    end update_company_direct_cycle;

    procedure update_company_long_cycle is

        l_top_id    companies.company_id%type;
        l_middle_id companies.company_id%type;
        l_bottom_id companies.company_id%type;
    begin
        l_top_id := new_company;
        l_middle_id := new_company(l_top_id);
        l_bottom_id := new_company(l_middle_id);
        set_parent(l_top_id, l_bottom_id);
    end update_company_long_cycle;

    procedure update_company_cycle_names_companies is
        l_parent_id companies.company_id%type;
        l_child_id  companies.company_id%type;
    begin
        l_parent_id := company_api.create_company('Groupe');
        l_child_id := company_api.create_company(
            in_company_name      => 'Filiale',
            in_parent_company_id => l_parent_id
        );
        set_parent(l_parent_id, l_child_id);
        ut.fail('Cycle accepté');
    exception
        when app_errors.e_circular_reference then
            ut.expect(sqlerrm).to_be_like('%« Groupe » ne peut pas avoir « Filiale » comme entreprise parente%');
    end update_company_cycle_names_companies;

    procedure delete_company_removes_row is
        l_company_id companies.company_id%type;
        l_count      pls_integer;
    begin
        l_company_id := new_company;
        company_api.delete_company(l_company_id);
        select
            count(*)
        into l_count
        from
            companies
        where
            company_id = l_company_id;

        ut.expect(l_count).to_equal(0);
    end delete_company_removes_row;

    procedure delete_company_unknown is
    begin
        company_api.delete_company(co_unknown_company_id);
    end delete_company_unknown;

    procedure delete_company_referenced is
        l_parent_id companies.company_id%type;
        l_child_id  companies.company_id%type;
    begin
        l_parent_id := new_company;
        l_child_id := new_company(l_parent_id);
        company_api.delete_company(l_parent_id);
    end delete_company_referenced;

    procedure delete_company_readable_error is
        l_parent_id companies.company_id%type;
        l_child_id  companies.company_id%type;
    begin
        l_parent_id := new_company;
        l_child_id := new_company(l_parent_id);
        company_api.delete_company(l_parent_id);
        ut.fail('Suppression acceptée');
    exception
        when app_errors.e_row_referenced then
            ut.expect(sqlerrm).to_be_like('%suppression impossible%');
    end delete_company_readable_error;

    procedure delete_company_error_names_company is
        l_parent_id companies.company_id%type;
        l_child_id  companies.company_id%type;
    begin
        l_parent_id := company_api.create_company('Groupe');
        l_child_id := new_company(l_parent_id);
        company_api.delete_company(l_parent_id);
        ut.fail('Suppression acceptée');
    exception
        when app_errors.e_row_referenced then
            ut.expect(sqlerrm).to_be_like('%« Groupe »%');
    end delete_company_error_names_company;

    procedure delete_company_with_positions is
        l_company_id companies.company_id%type;
    begin
        l_company_id := new_company;
        add_position(l_company_id);
        company_api.delete_company(l_company_id);
    end delete_company_with_positions;

    procedure delete_company_deletes_positions is
        l_company_id companies.company_id%type;
    begin
        l_company_id := new_company;
        add_position(l_company_id);
        company_api.delete_company(l_company_id,
                                   in_delete_positions => true);
        ut.expect(count_positions(l_company_id)).to_equal(0);
    end delete_company_deletes_positions;

    procedure delete_company_parent_keeps_positions is
        l_parent_id companies.company_id%type;
        l_child_id  companies.company_id%type;
    begin
        l_parent_id := new_company;
        l_child_id := new_company(l_parent_id);
        add_position(l_parent_id);
        company_api.delete_company(l_parent_id,
                                   in_delete_positions => true);
        ut.fail('Suppression acceptée');
    exception
        when app_errors.e_row_referenced then
            ut.expect(count_positions(l_parent_id)).to_equal(1);
    end delete_company_parent_keeps_positions;

    procedure delete_company_generic is
    begin
        company_api.delete_company(generic_company_id);
    end delete_company_generic;

    procedure delete_company_generic_readable_error is
    begin
        company_api.delete_company(generic_company_id);
        ut.fail('Suppression acceptée');
    exception
        when app_errors.e_protected_row then
            ut.expect(sqlerrm).to_be_like('%ne peut pas être supprimée%');
    end delete_company_generic_readable_error;

    procedure generic_company_exists is
    begin
        ut.expect(generic_company_id).to_be_not_null();
    end generic_company_exists;

    procedure generic_company_renamable is
        l_company_id companies.company_id%type;
    begin
        l_company_id := generic_company_id;
        company_api.update_company(
            in_company_id        => l_company_id,
            in_company_name      => 'Anonyme',
            in_description       => null,
            in_note_text         => null,
            in_parent_company_id => null,
            in_company_type_id   => null,
            in_sector_id         => null,
            in_company_size_id   => null,
            in_location_id       => null,
            in_siren             => null,
            in_website_url       => null,
            in_linkedin_slug     => null,
            in_email             => null,
            in_phone             => null,
            in_creation_year     => null
        );

        ut.expect(get_company(l_company_id).company_name).to_equal('Anonyme');
        ut.expect(get_company(l_company_id).is_generic).to_be_true();
    end generic_company_renamable;

    procedure generic_company_unique is
        l_company_id companies.company_id%type;
    begin
        l_company_id := new_company;
        update companies
        set
            is_generic = true
        where
            company_id = l_company_id;

    end generic_company_unique;

    procedure create_company_not_generic is
    begin
        ut.expect(get_company(new_company).is_generic).to_be_false();
    end create_company_not_generic;

    procedure company_name_required is
        l_company_id companies.company_id%type;
    begin
        l_company_id := company_api.create_company(null);
    end company_name_required;

    procedure siren_unique is
        l_company_id companies.company_id%type;
    begin
        l_company_id := company_api.create_company('A',
                                                   in_siren => '123456789');
        l_company_id := company_api.create_company('B',
                                                   in_siren => '123456789');
    end siren_unique;

    procedure siren_format is
        l_company_id companies.company_id%type;
    begin
        l_company_id := company_api.create_company('A',
                                                   in_siren => '12345678A');
    end siren_format;

    procedure linkedin_slug_format is
        l_company_id companies.company_id%type;
    begin
        l_company_id := company_api.create_company('A',
                                                   in_linkedin_slug => 'company/acme');
    end linkedin_slug_format;

end test_company_api;
/

create or replace package body jobtracker.test_contact_api is

    co_unknown_contact_id    constant contacts.contact_id%type := -1;
    co_unknown_salutation_id constant salutations.salutation_id%type := -1;
    co_unknown_position_id   constant contact_positions.contact_position_id%type := -1;

    /** Poste de test du contact donné, dans une nouvelle entreprise. */
    function new_position (
        in_contact_id in contacts.contact_id%type
    ) return contact_positions.contact_position_id%type is
    begin
        return contact_api.create_position(
            in_contact_id => in_contact_id,
            in_company_id => company_api.create_company('Test'),
            in_job_id     => job_api.create_job('Test scout', 'Éclaireur de test'),
            in_is_current => true
        );
    end new_position;

    /** Ligne du poste donné. */
    function get_position (
        in_contact_position_id in contact_positions.contact_position_id%type
    ) return contact_positions%rowtype is
        r_position contact_positions%rowtype;
    begin
        select
            *
        into r_position
        from
            contact_positions
        where
            contact_position_id = in_contact_position_id;

        return r_position;
    end get_position;

    /** Nombre de postes du contact donné. */
    function count_positions (
        in_contact_id in contacts.contact_id%type
    ) return pls_integer is
        l_count pls_integer;
    begin
        select
            count(*)
        into l_count
        from
            contact_positions
        where
            contact_id = in_contact_id;

        return l_count;
    end count_positions;

    /** Ligne du contact donné. */
    function get_contact (
        in_contact_id in contacts.contact_id%type
    ) return contacts%rowtype is
        r_contact contacts%rowtype;
    begin
        select
            *
        into r_contact
        from
            contacts
        where
            contact_id = in_contact_id;

        return r_contact;
    end get_contact;

    /** Remplace le nom d'un contact, les autres colonnes étant vidées. */
    procedure set_last_name (
        in_contact_id in contacts.contact_id%type,
        in_last_name  in contacts.last_name%type
    ) is
    begin
        contact_api.update_contact(
            in_contact_id    => in_contact_id,
            in_last_name     => in_last_name,
            in_first_name    => null,
            in_salutation_id => null,
            in_email         => null,
            in_phone         => null,
            in_linkedin_slug => null,
            in_note_text     => null
        );
    end set_last_name;

    procedure create_contact_last_name_only is
        r_contact contacts%rowtype;
    begin
        r_contact := get_contact(contact_api.create_contact('Martin'));
        ut.expect(r_contact.last_name).to_equal('Martin');
        ut.expect(r_contact.first_name).to_be_null();
        ut.expect(r_contact.created_at).to_be_not_null();
        ut.expect(r_contact.updated_at).to_be_not_null();
    end create_contact_last_name_only;

    procedure create_contact_all_columns is
        l_salutation_id salutations.salutation_id%type;
        r_contact       contacts%rowtype;
    begin
        select
            salutation_id
        into l_salutation_id
        from
            salutations
        where
            salutation_code = 'MS';

        r_contact := get_contact(contact_api.create_contact(
            in_last_name     => 'Martin',
            in_first_name    => 'Claire',
            in_salutation_id => l_salutation_id,
            in_email         => 'claire.martin@example.test',
            in_phone         => '0102030405',
            in_linkedin_slug => 'claire-martin',
            in_note_text     => to_clob('Note')
        ));

        ut.expect(r_contact.first_name).to_equal('Claire');
        ut.expect(r_contact.salutation_id).to_equal(l_salutation_id);
        ut.expect(r_contact.email).to_equal('claire.martin@example.test');
        ut.expect(r_contact.phone).to_equal('0102030405');
        ut.expect(r_contact.linkedin_slug).to_equal('claire-martin');
        ut.expect(r_contact.note_text).to_equal(to_clob('Note'));
    end create_contact_all_columns;

    procedure update_contact_replaces_columns is
        l_contact_id contacts.contact_id%type;
        r_contact    contacts%rowtype;
    begin
        l_contact_id := contact_api.create_contact(
            in_last_name  => 'Avant',
            in_first_name => 'Claire'
        );
        contact_api.update_contact(
            in_contact_id    => l_contact_id,
            in_last_name     => 'Après',
            in_first_name    => null,
            in_salutation_id => null,
            in_email         => null,
            in_phone         => null,
            in_linkedin_slug => null,
            in_note_text     => to_clob('Note')
        );

        r_contact := get_contact(l_contact_id);
        ut.expect(r_contact.last_name).to_equal('Après');
        ut.expect(r_contact.note_text).to_equal(to_clob('Note'));
        ut.expect(r_contact.first_name).to_be_null();
    end update_contact_replaces_columns;

    procedure update_contact_sets_updated_at is
        l_contact_id contacts.contact_id%type;
        r_before     contacts%rowtype;
        r_after      contacts%rowtype;
    begin
        l_contact_id := contact_api.create_contact('Martin');
        update contacts
        set
            created_at = systimestamp - interval '1' day,
            updated_at = systimestamp - interval '1' day
        where
            contact_id = l_contact_id;

        r_before := get_contact(l_contact_id);
        set_last_name(l_contact_id, 'Durand');
        r_after := get_contact(l_contact_id);
        ut.expect(r_after.updated_at).to_be_greater_than(r_before.updated_at);
        ut.expect(r_after.created_at).to_equal(r_before.created_at);
    end update_contact_sets_updated_at;

    procedure update_contact_unknown is
    begin
        set_last_name(co_unknown_contact_id, 'Martin');
    end update_contact_unknown;

    procedure delete_contact_removes_row is
        l_contact_id contacts.contact_id%type;
        l_count      pls_integer;
    begin
        l_contact_id := contact_api.create_contact('Martin');
        contact_api.delete_contact(l_contact_id);
        select
            count(*)
        into l_count
        from
            contacts
        where
            contact_id = l_contact_id;

        ut.expect(l_count).to_equal(0);
    end delete_contact_removes_row;

    procedure delete_contact_unknown is
    begin
        contact_api.delete_contact(co_unknown_contact_id);
    end delete_contact_unknown;

    procedure delete_contact_with_positions is
        l_contact_id          contacts.contact_id%type;
        l_contact_position_id contact_positions.contact_position_id%type;
    begin
        l_contact_id := contact_api.create_contact('Martin');
        l_contact_position_id := new_position(l_contact_id);
        contact_api.delete_contact(l_contact_id);
    end delete_contact_with_positions;

    procedure delete_contact_error_names_contact is
        l_contact_id          contacts.contact_id%type;
        l_contact_position_id contact_positions.contact_position_id%type;
    begin
        l_contact_id := contact_api.create_contact('Martin',
                                                   in_first_name => 'Claire');
        l_contact_position_id := new_position(l_contact_id);
        contact_api.delete_contact(l_contact_id);
        ut.fail('Suppression acceptée');
    exception
        when app_errors.e_row_referenced then
            ut.expect(sqlerrm).to_be_like('%« Claire Martin »%');
            ut.expect(count_positions(l_contact_id)).to_equal(1);
    end delete_contact_error_names_contact;

    procedure delete_contact_deletes_positions is
        l_contact_id          contacts.contact_id%type;
        l_contact_position_id contact_positions.contact_position_id%type;
        l_count               pls_integer;
    begin
        l_contact_id := contact_api.create_contact('Martin');
        l_contact_position_id := new_position(l_contact_id);
        contact_api.delete_contact(l_contact_id,
                                   in_delete_positions => true);
        ut.expect(count_positions(l_contact_id)).to_equal(0);
        select
            count(*)
        into l_count
        from
            contacts
        where
            contact_id = l_contact_id;

        ut.expect(l_count).to_equal(0);
    end delete_contact_deletes_positions;

    procedure create_position_all_columns is

        l_contact_id contacts.contact_id%type;
        l_company_id companies.company_id%type;
        l_job_id     jobs.job_id%type;
        r_position   contact_positions%rowtype;
    begin
        l_contact_id := contact_api.create_contact('Martin');
        l_company_id := company_api.create_company('Test');
        l_job_id := job_api.create_job('Test scout', 'Éclaireur de test');
        r_position := get_position(contact_api.create_position(l_contact_id, l_company_id, l_job_id, false));

        ut.expect(r_position.contact_id).to_equal(l_contact_id);
        ut.expect(r_position.company_id).to_equal(l_company_id);
        ut.expect(r_position.job_id).to_equal(l_job_id);
        ut.expect(r_position.is_current).to_be_false();
        ut.expect(r_position.created_at).to_be_not_null();
        ut.expect(r_position.updated_at).to_be_not_null();
    end create_position_all_columns;

    procedure create_position_several_current is
        l_contact_id          contacts.contact_id%type;
        l_contact_position_id contact_positions.contact_position_id%type;
    begin
        l_contact_id := contact_api.create_contact('Martin');
        l_contact_position_id := new_position(l_contact_id);
        l_contact_position_id := contact_api.create_position(
            in_contact_id => l_contact_id,
            in_company_id => company_api.create_company('Autre'),
            in_job_id     => job_api.create_job('Other scout', 'Autre éclaireur'),
            in_is_current => true
        );

        ut.expect(count_positions(l_contact_id)).to_equal(2);
    end create_position_several_current;

    procedure create_position_duplicate is
        r_position            contact_positions%rowtype;
        l_contact_position_id contact_positions.contact_position_id%type;
    begin
        r_position := get_position(new_position(contact_api.create_contact('Martin')));
        l_contact_position_id := contact_api.create_position(r_position.contact_id, r_position.company_id, r_position.job_id, false);

    end create_position_duplicate;

    procedure update_position_replaces_columns is

        l_contact_position_id contact_positions.contact_position_id%type;
        l_company_id          companies.company_id%type;
        l_job_id              jobs.job_id%type;
        r_before              contact_positions%rowtype;
        r_after               contact_positions%rowtype;
    begin
        l_contact_position_id := new_position(contact_api.create_contact('Martin'));
        update contact_positions
        set
            created_at = systimestamp - interval '1' day,
            updated_at = systimestamp - interval '1' day
        where
            contact_position_id = l_contact_position_id;

        r_before := get_position(l_contact_position_id);
        l_company_id := company_api.create_company('Autre');
        l_job_id := job_api.create_job('Other scout', 'Autre éclaireur');
        contact_api.update_position(l_contact_position_id, l_company_id, l_job_id, false);
        r_after := get_position(l_contact_position_id);
        ut.expect(r_after.contact_id).to_equal(r_before.contact_id);
        ut.expect(r_after.company_id).to_equal(l_company_id);
        ut.expect(r_after.job_id).to_equal(l_job_id);
        ut.expect(r_after.is_current).to_be_false();
        ut.expect(r_after.updated_at).to_be_greater_than(r_before.updated_at);
        ut.expect(r_after.created_at).to_equal(r_before.created_at);
    end update_position_replaces_columns;

    procedure update_position_unknown is
    begin
        contact_api.update_position(co_unknown_position_id,
                                    company_api.create_company('Test'),
                                    job_api.create_job('Test scout', 'Éclaireur de test'),
                                    true);
    end update_position_unknown;

    procedure delete_position_removes_row is
        l_contact_id contacts.contact_id%type;
    begin
        l_contact_id := contact_api.create_contact('Martin');
        contact_api.delete_position(new_position(l_contact_id));
        ut.expect(count_positions(l_contact_id)).to_equal(0);
    end delete_position_removes_row;

    procedure delete_position_unknown is
    begin
        contact_api.delete_position(co_unknown_position_id);
    end delete_position_unknown;

    procedure last_name_required is
        l_contact_id contacts.contact_id%type;
    begin
        l_contact_id := contact_api.create_contact(null);
    end last_name_required;

    procedure salutation_must_exist is
        l_contact_id contacts.contact_id%type;
    begin
        l_contact_id := contact_api.create_contact('Martin',
                                                   in_salutation_id => co_unknown_salutation_id);
    end salutation_must_exist;

    procedure linkedin_slug_format is
        l_contact_id contacts.contact_id%type;
    begin
        l_contact_id := contact_api.create_contact('Martin',
                                                   in_linkedin_slug => 'in/claire-martin');
    end linkedin_slug_format;

end test_contact_api;
/

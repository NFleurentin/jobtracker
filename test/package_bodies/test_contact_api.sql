create or replace package body jobtracker.test_contact_api is

    co_unknown_contact_id    constant contacts.contact_id%type := -1;
    co_unknown_salutation_id constant salutations.salutation_id%type := -1;

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

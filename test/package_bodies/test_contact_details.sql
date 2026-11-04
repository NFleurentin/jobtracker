create or replace package body jobtracker.test_contact_details is

    /** Ligne de la vue pour le contact donné. */
    function get_details (
        in_contact_id in contacts.contact_id%type
    ) return contact_details%rowtype is
        r_details contact_details%rowtype;
    begin
        select
            *
        into r_details
        from
            contact_details
        where
            contact_id = in_contact_id;

        return r_details;
    end get_details;

    /** Première civilité du référentiel. */
    function first_salutation return salutations%rowtype is
        r_salutation salutations%rowtype;
    begin
        select
            *
        into r_salutation
        from
            salutations
        order by
            salutation_id
        fetch first 1 row only;

        return r_salutation;
    end first_salutation;

    procedure contact_without_salutation is
        r_details contact_details%rowtype;
    begin
        r_details := get_details(contact_api.create_contact('Martin'));
        ut.expect(r_details.last_name).to_equal('Martin');
        ut.expect(r_details.salutation_short_name).to_be_null();
        ut.expect(r_details.salutation_long_name).to_be_null();
    end contact_without_salutation;

    procedure salutation_labels_in_french is
        r_salutation salutations%rowtype;
        r_details    contact_details%rowtype;
    begin
        r_salutation := first_salutation;
        r_details := get_details(contact_api.create_contact(
            in_last_name     => 'Martin',
            in_salutation_id => r_salutation.salutation_id
        ));

        ut.expect(r_details.salutation_short_name).to_equal(r_salutation.salutation_short_name_fr);
        ut.expect(r_details.salutation_long_name).to_equal(r_salutation.salutation_long_name_fr);
    end salutation_labels_in_french;

    procedure salutation_labels_in_english_session is
        r_salutation salutations%rowtype;
        r_details    contact_details%rowtype;
    begin
        -- La langue vient de la session APEX (app_message.current_language),
        -- ouverte par test_helpers.start_english_session
        r_salutation := first_salutation;
        r_details := get_details(contact_api.create_contact(
            in_last_name     => 'Martin',
            in_salutation_id => r_salutation.salutation_id
        ));

        ut.expect(r_details.salutation_short_name).to_equal(r_salutation.salutation_short_name_en);
        ut.expect(r_details.salutation_long_name).to_equal(r_salutation.salutation_long_name_en);
    end salutation_labels_in_english_session;

end test_contact_details;
/

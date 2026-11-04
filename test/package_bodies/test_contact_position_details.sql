create or replace package body jobtracker.test_contact_position_details is

    /** Ligne de la vue pour le poste donné. */
    function get_details (
        in_contact_position_id in contact_positions.contact_position_id%type
    ) return contact_position_details%rowtype is
        r_details contact_position_details%rowtype;
    begin
        select
            *
        into r_details
        from
            contact_position_details
        where
            contact_position_id = in_contact_position_id;

        return r_details;
    end get_details;

    /** Premier poste du référentiel. */
    function first_job return jobs%rowtype is
        r_job jobs%rowtype;
    begin
        select
            *
        into r_job
        from
            jobs
        order by
            job_id
        fetch first 1 row only;

        return r_job;
    end first_job;

    /** Poste actuel d'un nouveau contact dans une nouvelle entreprise. */
    function new_position (
        in_job_id in jobs.job_id%type
    ) return contact_positions.contact_position_id%type is
    begin
        return contact_api.create_position(
            in_contact_id => contact_api.create_contact(
                in_last_name  => 'Martin',
                in_first_name => 'Claire'
            ),
            in_company_id => company_api.create_company('Acme'),
            in_job_id     => in_job_id,
            in_is_current => true
        );
    end new_position;

    procedure position_with_contact_and_company is
        r_details contact_position_details%rowtype;
    begin
        r_details := get_details(new_position(first_job().job_id));
        ut.expect(r_details.last_name).to_equal('Martin');
        ut.expect(r_details.first_name).to_equal('Claire');
        ut.expect(r_details.company_name).to_equal('Acme');
        ut.expect(r_details.is_current).to_be_true();
    end position_with_contact_and_company;

    procedure one_row_per_position is
        l_contact_id          contacts.contact_id%type;
        l_contact_position_id contact_positions.contact_position_id%type;
        l_count               pls_integer;
    begin
        -- Deux postes du même contact, dans deux entreprises
        l_contact_id := contact_api.create_contact('Martin');
        l_contact_position_id := contact_api.create_position(
            in_contact_id => l_contact_id,
            in_company_id => company_api.create_company('Acme'),
            in_job_id     => first_job().job_id,
            in_is_current => true
        );

        l_contact_position_id := contact_api.create_position(
            in_contact_id => l_contact_id,
            in_company_id => company_api.create_company('Globex'),
            in_job_id     => first_job().job_id,
            in_is_current => false
        );

        select
            count(*)
        into l_count
        from
            contact_position_details
        where
            contact_id = l_contact_id;

        ut.expect(l_count).to_equal(2);
    end one_row_per_position;

    procedure job_name_in_french is
        r_job     jobs%rowtype;
        r_details contact_position_details%rowtype;
    begin
        r_job := first_job;
        r_details := get_details(new_position(r_job.job_id));
        ut.expect(r_details.job_name).to_equal(r_job.job_name_fr);
    end job_name_in_french;

    procedure job_name_in_english_session is
        r_job     jobs%rowtype;
        r_details contact_position_details%rowtype;
    begin
        -- La langue vient de la session APEX (app_message.current_language),
        -- ouverte par test_helpers.start_english_session
        r_job := first_job;
        r_details := get_details(new_position(r_job.job_id));
        ut.expect(r_details.job_name).to_equal(r_job.job_name_en);
    end job_name_in_english_session;

end test_contact_position_details;
/

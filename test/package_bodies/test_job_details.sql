create or replace package body jobtracker.test_job_details is

    /** Ligne de la vue pour le poste donné. */
    function get_details (
        in_job_id in jobs.job_id%type
    ) return job_details%rowtype is
        r_details job_details%rowtype;
    begin
        select
            *
        into r_details
        from
            job_details
        where
            job_id = in_job_id;

        return r_details;
    end get_details;

    procedure job_without_position is
        r_details job_details%rowtype;
    begin
        r_details := get_details(job_api.create_job(
            in_job_name_en => 'Test job',
            in_job_name_fr => 'Poste de test'
        ));

        ut.expect(r_details.job_name_en).to_equal('Test job');
        ut.expect(r_details.job_name_fr).to_equal('Poste de test');
        ut.expect(r_details.position_count).to_equal(0);
    end job_without_position;

    procedure position_count is

        l_job_id              jobs.job_id%type;
        l_other_job_id        jobs.job_id%type;
        l_company_id          companies.company_id%type;
        l_contact_position_id contact_positions.contact_position_id%type;
    begin
        l_job_id := job_api.create_job(
            in_job_name_en => 'Test job',
            in_job_name_fr => 'Poste de test'
        );
        l_other_job_id := job_api.create_job(
            in_job_name_en => 'Other test job',
            in_job_name_fr => 'Autre poste de test'
        );
        l_company_id := company_api.create_company('Acme');

        -- Deux contacts au poste testé, un troisième à l'autre poste
        l_contact_position_id := contact_api.create_position(
            in_contact_id => contact_api.create_contact('Martin'),
            in_company_id => l_company_id,
            in_job_id     => l_job_id,
            in_is_current => true
        );

        l_contact_position_id := contact_api.create_position(
            in_contact_id => contact_api.create_contact('Durand'),
            in_company_id => l_company_id,
            in_job_id     => l_job_id,
            in_is_current => false
        );

        l_contact_position_id := contact_api.create_position(
            in_contact_id => contact_api.create_contact('Bernard'),
            in_company_id => l_company_id,
            in_job_id     => l_other_job_id,
            in_is_current => true
        );

        ut.expect(get_details(l_job_id).position_count).to_equal(2);
        ut.expect(get_details(l_other_job_id).position_count).to_equal(1);
    end position_count;

end test_job_details;
/

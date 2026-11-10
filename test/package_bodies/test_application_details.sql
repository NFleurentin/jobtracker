create or replace package body jobtracker.test_application_details is

    /** Ligne de la vue pour la candidature donnée. */
    function get_details (
        in_application_id in applications.application_id%type
    ) return application_details%rowtype is
        r_details application_details%rowtype;
    begin
        select
            *
        into r_details
        from
            application_details
        where
            application_id = in_application_id;

        return r_details;
    end get_details;

    /** Statut, par son code. */
    function get_status (
        in_code in application_statuses.application_status_code%type
    ) return application_statuses%rowtype is
        r_status application_statuses%rowtype;
    begin
        select
            *
        into r_status
        from
            application_statuses
        where
            application_status_code = in_code;

        return r_status;
    end get_status;

    /** Type « réponse à une offre ». */
    function job_offer_type return application_types%rowtype is
        r_type application_types%rowtype;
    begin
        select
            *
        into r_type
        from
            application_types
        where
            application_type_code = 'JOB_OFFER';

        return r_type;
    end job_offer_type;

    /** Candidature de test pour une nouvelle entreprise « Acme ». */
    function new_application (
        in_status_code in application_statuses.application_status_code%type default 'APPLIED',
        in_changed_at  in application_status_changes.changed_at%type default systimestamp
    ) return applications.application_id%type is
    begin
        return application_api.create_application(
            in_company_id            => company_api.create_company('Acme'),
            in_application_type_id   => job_offer_type().application_type_id,
            in_job_title             => 'Data engineer',
            in_application_status_id => get_status(in_status_code).application_status_id,
            in_changed_at            => in_changed_at
        );
    end new_application;

    /**
     * Ajoute un changement de statut directement dans la table : fixe la date
     * sans passer par les contrôles du package, hors du sujet de la vue.
     */
    procedure add_change (
        in_application_id in applications.application_id%type,
        in_status_code    in application_statuses.application_status_code%type,
        in_changed_at     in application_status_changes.changed_at%type
    ) is
        -- Fonction privée : non appelable dans l'ordre SQL
        l_application_status_id application_statuses.application_status_id%type := get_status(in_status_code).application_status_id;
    begin
        insert into application_status_changes (
            application_id,
            application_status_id,
            changed_at
        ) values
            ( in_application_id,
              l_application_status_id,
              in_changed_at );

    end add_change;

    procedure application_with_company_type_and_status is
        l_application_id applications.application_id%type;
        r_details        application_details%rowtype;
    begin
        l_application_id := new_application('REJECTED');
        r_details := get_details(l_application_id);
        ut.expect(r_details.company_name).to_equal('Acme');
        ut.expect(r_details.is_generic_company).to_be_false();
        ut.expect(r_details.application_type_code).to_equal('JOB_OFFER');
        ut.expect(r_details.job_title).to_equal('Data engineer');
        ut.expect(r_details.application_status_code).to_equal('REJECTED');
        ut.expect(r_details.application_status_display_order).to_equal(get_status('REJECTED').display_order);

        ut.expect(r_details.is_final).to_be_true();
        ut.expect(r_details.status_changed_at).to_be_not_null();
    end application_with_company_type_and_status;

    procedure one_row_per_application is
        l_application_id applications.application_id%type;
        l_count          pls_integer;
    begin
        l_application_id := new_application(in_changed_at => systimestamp - interval '2' day);
        add_change(l_application_id, 'INTERVIEWING', systimestamp - interval '1' day);
        add_change(l_application_id, 'OFFER_RECEIVED', systimestamp);
        select
            count(*)
        into l_count
        from
            application_details
        where
            application_id = l_application_id;

        ut.expect(l_count).to_equal(1);
    end one_row_per_application;

    procedure current_status_is_latest_changed_at is
        l_application_id applications.application_id%type;
    begin
        l_application_id := new_application(in_changed_at => systimestamp - interval '1' day);
        add_change(l_application_id, 'TO_APPLY', systimestamp - interval '7' day);
        ut.expect(get_details(l_application_id).application_status_code).to_equal('APPLIED');
    end current_status_is_latest_changed_at;

    procedure current_status_tie_broken_by_id is
        l_application_id applications.application_id%type;
        l_changed_at     application_status_changes.changed_at%type := timestamp '2026-03-01 09:00:00 +01:00';
    begin
        l_application_id := new_application(in_changed_at => l_changed_at);
        add_change(l_application_id, 'INTERVIEWING', l_changed_at);
        ut.expect(get_details(l_application_id).application_status_code).to_equal('INTERVIEWING');
    end current_status_tie_broken_by_id;

    procedure labels_in_french is
        r_details application_details%rowtype;
    begin
        r_details := get_details(new_application);
        ut.expect(r_details.application_type_name).to_equal(job_offer_type().application_type_name_fr);
        ut.expect(r_details.application_status_name).to_equal(get_status('APPLIED').application_status_name_fr);

    end labels_in_french;

    procedure labels_in_english_session is
        r_details application_details%rowtype;
    begin
        r_details := get_details(new_application);
        ut.expect(r_details.application_type_name).to_equal(job_offer_type().application_type_name_en);
        ut.expect(r_details.application_status_name).to_equal(get_status('APPLIED').application_status_name_en);

    end labels_in_english_session;

end test_application_details;
/

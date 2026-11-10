create or replace package body jobtracker.test_application_status_change_details is

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

    /** Candidature de test pour une nouvelle entreprise « Acme ». */
    function new_application (
        in_status_code in application_statuses.application_status_code%type default 'APPLIED',
        in_changed_at  in application_status_changes.changed_at%type default systimestamp
    ) return applications.application_id%type is
        l_application_type_id application_types.application_type_id%type;
    begin
        select
            application_type_id
        into l_application_type_id
        from
            application_types
        where
            application_type_code = 'JOB_OFFER';

        return application_api.create_application(
            in_company_id            => company_api.create_company('Acme'),
            in_application_type_id   => l_application_type_id,
            in_job_title             => 'Data engineer',
            in_application_status_id => get_status(in_status_code).application_status_id,
            in_changed_at            => in_changed_at
        );

    end new_application;

    /**
     * Ajoute un changement de statut directement dans la table : fixe la date
     * sans passer par les contrôles du package, hors du sujet de la vue.
     * @return identifiant du changement
     */
    function add_change (
        in_application_id in applications.application_id%type,
        in_status_code    in application_statuses.application_status_code%type,
        in_changed_at     in application_status_changes.changed_at%type
    ) return application_status_changes.application_status_change_id%type is
        -- Fonction privée : non appelable dans l'ordre SQL
        l_application_status_id application_statuses.application_status_id%type := get_status(in_status_code).application_status_id;
        l_change_id             application_status_changes.application_status_change_id%type;
    begin
        insert into application_status_changes (
            application_id,
            application_status_id,
            changed_at
        ) values
            ( in_application_id,
              l_application_status_id,
              in_changed_at )
        returning application_status_change_id into l_change_id;

        return l_change_id;
    end add_change;

    /** Identifiant du dernier changement de la candidature, selon la vue. */
    function latest_change_id (
        in_application_id in applications.application_id%type
    ) return application_status_changes.application_status_change_id%type is
        l_change_id application_status_changes.application_status_change_id%type;
    begin
        select
            application_status_change_id
        into l_change_id
        from
            application_status_change_details
        where
                application_id = in_application_id
            and is_latest;

        return l_change_id;
    end latest_change_id;

    /** Ligne de la vue pour le changement donné. */
    function get_details (
        in_change_id in application_status_changes.application_status_change_id%type
    ) return application_status_change_details%rowtype is
        r_details application_status_change_details%rowtype;
    begin
        select
            *
        into r_details
        from
            application_status_change_details
        where
            application_status_change_id = in_change_id;

        return r_details;
    end get_details;

    procedure one_row_per_change is
        l_application_id applications.application_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
        l_count          pls_integer;
    begin
        l_application_id := new_application(in_changed_at => systimestamp - interval '2' day);
        l_change_id := add_change(l_application_id, 'INTERVIEWING', systimestamp - interval '1' day);
        l_change_id := add_change(l_application_id, 'OFFER_RECEIVED', systimestamp);
        select
            count(*)
        into l_count
        from
            application_status_change_details
        where
            application_id = l_application_id;

        ut.expect(l_count).to_equal(3);
    end one_row_per_change;

    procedure single_latest_change is
        l_application_id applications.application_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
        l_count          pls_integer;
    begin
        l_application_id := new_application(in_changed_at => systimestamp - interval '2' day);
        l_change_id := add_change(l_application_id, 'INTERVIEWING', systimestamp - interval '1' day);
        l_change_id := add_change(l_application_id, 'OFFER_RECEIVED', systimestamp);
        select
            count(*)
        into l_count
        from
            application_status_change_details
        where
                application_id = l_application_id
            and is_latest;

        ut.expect(l_count).to_equal(1);
    end single_latest_change;

    procedure latest_is_latest_changed_at is
        l_application_id applications.application_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
    begin
        l_application_id := new_application(in_changed_at => systimestamp - interval '1' day);
        -- Saisi après, mais daté avant : n'est pas le dernier
        l_change_id := add_change(l_application_id, 'TO_APPLY', systimestamp - interval '7' day);
        ut.expect(get_details(l_change_id).is_latest).to_be_false();
        ut.expect(get_details(latest_change_id(l_application_id)).application_status_code).to_equal('APPLIED');

    end latest_is_latest_changed_at;

    procedure latest_tie_broken_by_id is

        l_application_id applications.application_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
        l_changed_at     application_status_changes.changed_at%type := timestamp '2026-03-01 09:00:00 +01:00';
    begin
        l_application_id := new_application(in_changed_at => l_changed_at);
        l_change_id := add_change(l_application_id, 'INTERVIEWING', l_changed_at);
        ut.expect(latest_change_id(l_application_id)).to_equal(l_change_id);
    end latest_tie_broken_by_id;

    procedure latest_matches_current_status is

        l_application_id applications.application_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
        l_current_status application_details.application_status_id%type;
    begin
        l_application_id := new_application(in_changed_at => systimestamp - interval '2' day);
        l_change_id := add_change(l_application_id, 'INTERVIEWING', systimestamp - interval '1' day);
        l_change_id := add_change(l_application_id, 'TO_APPLY', systimestamp - interval '3' day);
        select
            application_status_id
        into l_current_status
        from
            application_details
        where
            application_id = l_application_id;

        ut.expect(get_details(latest_change_id(l_application_id)).application_status_id).to_equal(l_current_status);

    end latest_matches_current_status;

    procedure labels_in_french is
        l_application_id applications.application_id%type;
        r_details        application_status_change_details%rowtype;
    begin
        l_application_id := new_application;
        r_details := get_details(latest_change_id(l_application_id));
        ut.expect(r_details.application_status_name).to_equal(get_status('APPLIED').application_status_name_fr);

        ut.expect(r_details.application_status_display_order).to_equal(get_status('APPLIED').display_order);

    end labels_in_french;

    procedure labels_in_english_session is
        l_application_id applications.application_id%type;
        r_details        application_status_change_details%rowtype;
    begin
        l_application_id := new_application;
        r_details := get_details(latest_change_id(l_application_id));
        ut.expect(r_details.application_status_name).to_equal(get_status('APPLIED').application_status_name_en);

    end labels_in_english_session;

end test_application_status_change_details;
/

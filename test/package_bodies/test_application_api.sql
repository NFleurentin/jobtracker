create or replace package body jobtracker.test_application_api is

    co_unknown_id constant number := -1;

    /** Identifiant d'un statut, par son code. */
    function status_id (
        in_code in application_statuses.application_status_code%type
    ) return application_statuses.application_status_id%type is
        l_id application_statuses.application_status_id%type;
    begin
        select
            application_status_id
        into l_id
        from
            application_statuses
        where
            application_status_code = in_code;

        return l_id;
    end status_id;

    /** Identifiant du type « réponse à une offre ». */
    function job_offer_type_id return application_types.application_type_id%type is
        l_id application_types.application_type_id%type;
    begin
        select
            application_type_id
        into l_id
        from
            application_types
        where
            application_type_code = 'JOB_OFFER';

        return l_id;
    end job_offer_type_id;

    /** Identifiant de l'entreprise générique. */
    function generic_company_id return companies.company_id%type is
        l_id companies.company_id%type;
    begin
        select
            company_id
        into l_id
        from
            companies
        where
            is_generic = true;

        return l_id;
    end generic_company_id;

    /** Candidature de test, avec son statut initial. */
    function new_application (
        in_company_id  in companies.company_id%type,
        in_status_code in application_statuses.application_status_code%type default 'APPLIED',
        in_changed_at  in application_status_changes.changed_at%type default systimestamp
    ) return applications.application_id%type is
    begin
        return application_api.create_application(
            in_company_id            => in_company_id,
            in_application_type_id   => job_offer_type_id,
            in_job_title             => 'Data engineer',
            in_application_status_id => status_id(in_status_code),
            in_changed_at            => in_changed_at
        );
    end new_application;

    /** Code du statut courant d'une candidature. */
    function current_status (
        in_application_id in applications.application_id%type
    ) return application_statuses.application_status_code%type is
        l_code application_statuses.application_status_code%type;
    begin
        select
            application_status_code
        into l_code
        from
            application_details
        where
            application_id = in_application_id;

        return l_code;
    end current_status;

    /** Nombre de changements de statut d'une candidature. */
    function count_changes (
        in_application_id in applications.application_id%type
    ) return pls_integer is
        l_count pls_integer;
    begin
        select
            count(*)
        into l_count
        from
            application_status_changes
        where
            application_id = in_application_id;

        return l_count;
    end count_changes;

    /** Nombre de candidatures d'une entreprise. */
    function count_applications (
        in_company_id in companies.company_id%type
    ) return pls_integer is
        l_count pls_integer;
    begin
        select
            count(*)
        into l_count
        from
            applications
        where
            company_id = in_company_id;

        return l_count;
    end count_applications;

    /** Ligne d'une candidature. */
    function get_application (
        in_application_id in applications.application_id%type
    ) return applications%rowtype is
        r_application applications%rowtype;
    begin
        select
            *
        into r_application
        from
            applications
        where
            application_id = in_application_id;

        return r_application;
    end get_application;

    /** Recule created_at et updated_at d'une candidature d'un jour. */
    procedure age_application (
        in_application_id in applications.application_id%type
    ) is
    begin
        update applications
        set
            created_at = systimestamp - interval '1' day,
            updated_at = systimestamp - interval '1' day
        where
            application_id = in_application_id;

    end age_application;

    procedure create_application_with_initial_status is
        l_application_id applications.application_id%type;
    begin
        l_application_id := new_application(company_api.create_company('Acme'));
        ut.expect(count_changes(l_application_id)).to_equal(1);
        ut.expect(current_status(l_application_id)).to_equal('APPLIED');
    end create_application_with_initial_status;

    procedure create_application_backdated is
        l_application_id applications.application_id%type;
        l_changed_at     application_status_changes.changed_at%type;
    begin
        l_application_id := new_application(
            company_api.create_company('Acme'),
            in_changed_at => timestamp '2026-01-15 10:00:00 +01:00'
        );

        select
            changed_at
        into l_changed_at
        from
            application_status_changes
        where
            application_id = l_application_id;

        ut.expect(l_changed_at).to_equal(timestamp '2026-01-15 10:00:00 +01:00');
    end create_application_backdated;

    procedure create_application_unknown_company is
        l_application_id applications.application_id%type;
    begin
        l_application_id := new_application(co_unknown_id);
    end create_application_unknown_company;

    procedure create_application_second_open is
        l_company_id     companies.company_id%type;
        l_application_id applications.application_id%type;
    begin
        l_company_id := company_api.create_company('Acme');
        l_application_id := new_application(l_company_id);
        l_application_id := new_application(l_company_id, 'TO_APPLY');
    end create_application_second_open;

    procedure create_application_second_open_message is
        l_company_id     companies.company_id%type;
        l_application_id applications.application_id%type;
    begin
        l_company_id := company_api.create_company('Acme');
        l_application_id := new_application(l_company_id);
        l_application_id := new_application(l_company_id);
        ut.fail('Deuxième candidature ouverte acceptée');
    exception
        when app_errors.e_duplicate_value then
            ut.expect(sqlerrm).to_be_like('%« Acme »%');
    end create_application_second_open_message;

    procedure create_application_refused_leaves_nothing is
        l_company_id     companies.company_id%type;
        l_application_id applications.application_id%type;
    begin
        l_company_id := company_api.create_company('Acme');
        l_application_id := new_application(l_company_id);
        begin
            l_application_id := new_application(l_company_id);
        exception
            when app_errors.e_duplicate_value then
                null;
        end;

        ut.expect(count_applications(l_company_id)).to_equal(1);
    end create_application_refused_leaves_nothing;

    procedure create_application_after_closed is
        l_company_id     companies.company_id%type;
        l_application_id applications.application_id%type;
    begin
        l_company_id := company_api.create_company('Acme');
        l_application_id := new_application(l_company_id, 'REJECTED');
        l_application_id := new_application(l_company_id);
        ut.expect(count_applications(l_company_id)).to_equal(2);
    end create_application_after_closed;

    procedure create_application_closed_beside_open is
        l_company_id     companies.company_id%type;
        l_application_id applications.application_id%type;
    begin
        l_company_id := company_api.create_company('Acme');
        l_application_id := new_application(l_company_id);
        l_application_id := new_application(l_company_id, 'WITHDRAWN');
        ut.expect(count_applications(l_company_id)).to_equal(2);
    end create_application_closed_beside_open;

    procedure create_application_generic_company is
        l_application_id applications.application_id%type;
    begin
        l_application_id := new_application(generic_company_id);
        l_application_id := new_application(generic_company_id);
        ut.expect(current_status(l_application_id)).to_equal('APPLIED');
    end create_application_generic_company;

    procedure update_application_replaces_columns is
        l_application_id applications.application_id%type;
        r_application    applications%rowtype;
    begin
        l_application_id := application_api.create_application(
            in_company_id                   => company_api.create_company('Acme'),
            in_application_type_id          => job_offer_type_id,
            in_job_title                    => 'Avant',
            in_application_status_id        => status_id('APPLIED'),
            in_annual_salary_proposed_euros => 50000
        );

        application_api.update_application(
            in_application_id               => l_application_id,
            in_company_id                   => get_application(l_application_id).company_id,
            in_application_type_id          => job_offer_type_id,
            in_job_title                    => 'Après',
            in_annual_salary_proposed_euros => null,
            in_daily_rate_proposed_euros    => 600,
            in_interest_rating              => 4,
            in_note_text                    => to_clob('Note')
        );

        r_application := get_application(l_application_id);
        ut.expect(r_application.job_title).to_equal('Après');
        ut.expect(r_application.annual_salary_proposed_euros).to_be_null();
        ut.expect(r_application.daily_rate_proposed_euros).to_equal(600);
        ut.expect(r_application.interest_rating).to_equal(4);
        ut.expect(r_application.note_text).to_equal(to_clob('Note'));
    end update_application_replaces_columns;

    procedure update_application_sets_updated_at is
        l_application_id applications.application_id%type;
        r_before         applications%rowtype;
        r_after          applications%rowtype;
    begin
        l_application_id := new_application(company_api.create_company('Acme'));
        age_application(l_application_id);
        r_before := get_application(l_application_id);
        application_api.update_application(
            in_application_id               => l_application_id,
            in_company_id                   => r_before.company_id,
            in_application_type_id          => r_before.application_type_id,
            in_job_title                    => r_before.job_title,
            in_annual_salary_proposed_euros => null,
            in_daily_rate_proposed_euros    => null,
            in_interest_rating              => null,
            in_note_text                    => null
        );

        r_after := get_application(l_application_id);
        ut.expect(r_after.updated_at).to_be_greater_than(r_before.updated_at);
        ut.expect(r_after.created_at).to_equal(r_before.created_at);
    end update_application_sets_updated_at;

    procedure update_application_unknown is
    begin
        application_api.update_application(
            in_application_id               => co_unknown_id,
            in_company_id                   => company_api.create_company('Acme'),
            in_application_type_id          => job_offer_type_id,
            in_job_title                    => 'Data engineer',
            in_annual_salary_proposed_euros => null,
            in_daily_rate_proposed_euros    => null,
            in_interest_rating              => null,
            in_note_text                    => null
        );
    end update_application_unknown;

    procedure update_application_move_open is
        l_target_id      companies.company_id%type;
        l_application_id applications.application_id%type;
    begin
        l_target_id := company_api.create_company('Cible');
        l_application_id := new_application(l_target_id);
        l_application_id := new_application(company_api.create_company('Source'));
        application_api.update_application(
            in_application_id               => l_application_id,
            in_company_id                   => l_target_id,
            in_application_type_id          => job_offer_type_id,
            in_job_title                    => 'Data engineer',
            in_annual_salary_proposed_euros => null,
            in_daily_rate_proposed_euros    => null,
            in_interest_rating              => null,
            in_note_text                    => null
        );

    end update_application_move_open;

    procedure update_application_move_closed is
        l_target_id      companies.company_id%type;
        l_application_id applications.application_id%type;
    begin
        l_target_id := company_api.create_company('Cible');
        l_application_id := new_application(l_target_id);
        l_application_id := new_application(
            company_api.create_company('Source'),
            'REJECTED'
        );
        application_api.update_application(
            in_application_id               => l_application_id,
            in_company_id                   => l_target_id,
            in_application_type_id          => job_offer_type_id,
            in_job_title                    => 'Data engineer',
            in_annual_salary_proposed_euros => null,
            in_daily_rate_proposed_euros    => null,
            in_interest_rating              => null,
            in_note_text                    => null
        );

        ut.expect(count_applications(l_target_id)).to_equal(2);
    end update_application_move_closed;

    procedure delete_application_with_history is
        l_application_id applications.application_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
    begin
        l_application_id := new_application(company_api.create_company('Acme'));
        l_change_id := application_api.add_status_change(l_application_id,
                                                         status_id('INTERVIEWING'));
        application_api.delete_application(l_application_id);
        ut.expect(count_changes(l_application_id)).to_equal(0);
    end delete_application_with_history;

    procedure delete_application_unknown is
    begin
        application_api.delete_application(co_unknown_id);
    end delete_application_unknown;

    procedure add_status_change_becomes_current is
        l_application_id applications.application_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
    begin
        l_application_id := new_application(
            company_api.create_company('Acme'),
            in_changed_at => systimestamp - interval '1' day
        );

        l_change_id := application_api.add_status_change(l_application_id,
                                                         status_id('INTERVIEWING'));
        ut.expect(current_status(l_application_id)).to_equal('INTERVIEWING');
    end add_status_change_becomes_current;

    procedure add_status_change_backdated is
        l_application_id applications.application_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
    begin
        l_application_id := new_application(company_api.create_company('Acme'));
        l_change_id := application_api.add_status_change(
            in_application_id        => l_application_id,
            in_application_status_id => status_id('TO_APPLY'),
            in_changed_at            => systimestamp - interval '7' day
        );

        ut.expect(current_status(l_application_id)).to_equal('APPLIED');
    end add_status_change_backdated;

    procedure add_status_change_sets_updated_at is
        l_application_id applications.application_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
        r_before         applications%rowtype;
    begin
        l_application_id := new_application(company_api.create_company('Acme'));
        age_application(l_application_id);
        r_before := get_application(l_application_id);
        l_change_id := application_api.add_status_change(l_application_id,
                                                         status_id('INTERVIEWING'));
        ut.expect(get_application(l_application_id).updated_at).to_be_greater_than(r_before.updated_at);

    end add_status_change_sets_updated_at;

    procedure add_status_change_unknown is
        l_change_id application_status_changes.application_status_change_id%type;
    begin
        l_change_id := application_api.add_status_change(co_unknown_id,
                                                         status_id('APPLIED'));
    end add_status_change_unknown;

    procedure add_status_change_reopens is

        l_company_id     companies.company_id%type;
        l_application_id applications.application_id%type;
        l_other_id       applications.application_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
    begin
        l_company_id := company_api.create_company('Acme');
        l_application_id := new_application(l_company_id, 'REJECTED', systimestamp - interval '1' day);
        l_other_id := new_application(l_company_id);
        l_change_id := application_api.add_status_change(l_application_id,
                                                         status_id('INTERVIEWING'));
    end add_status_change_reopens;

    procedure add_status_change_refused_leaves_nothing is

        l_company_id     companies.company_id%type;
        l_application_id applications.application_id%type;
        l_other_id       applications.application_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
    begin
        l_company_id := company_api.create_company('Acme');
        l_application_id := new_application(l_company_id, 'REJECTED', systimestamp - interval '1' day);
        l_other_id := new_application(l_company_id);
        begin
            l_change_id := application_api.add_status_change(l_application_id,
                                                             status_id('INTERVIEWING'));
        exception
            when app_errors.e_duplicate_value then
                null;
        end;

        ut.expect(count_changes(l_application_id)).to_equal(1);
        ut.expect(current_status(l_application_id)).to_equal('REJECTED');
    end add_status_change_refused_leaves_nothing;

    /** Seul changement de statut d'une candidature. */
    function only_change_id (
        in_application_id in applications.application_id%type
    ) return application_status_changes.application_status_change_id%type is
        l_change_id application_status_changes.application_status_change_id%type;
    begin
        select
            application_status_change_id
        into l_change_id
        from
            application_status_changes
        where
            application_id = in_application_id;

        return l_change_id;
    end only_change_id;

    procedure correct_initial_status is
        l_application_id applications.application_id%type;
    begin
        l_application_id := new_application(
            company_api.create_company('Acme'),
            'REJECTED'
        );
        application_api.correct_latest_status_change(
            in_application_status_change_id => only_change_id(l_application_id),
            in_application_status_id        => status_id('APPLIED'),
            in_changed_at                   => systimestamp,
            in_note_text                    => null
        );

        ut.expect(current_status(l_application_id)).to_equal('APPLIED');
        ut.expect(count_changes(l_application_id)).to_equal(1);
    end correct_initial_status;

    procedure correct_latest_date is

        l_application_id applications.application_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
        l_changed_at     application_status_changes.changed_at%type;
    begin
        l_application_id := new_application(
            company_api.create_company('Acme'),
            in_changed_at => timestamp '2026-01-10 09:00:00 +01:00'
        );

        l_change_id := application_api.add_status_change(l_application_id,
                                                         status_id('INTERVIEWING'));
        application_api.correct_latest_status_change(
            in_application_status_change_id => l_change_id,
            in_application_status_id        => status_id('INTERVIEWING'),
            in_changed_at                   => timestamp '2026-01-20 14:00:00 +01:00',
            in_note_text                    => null
        );

        select
            changed_at
        into l_changed_at
        from
            application_status_changes
        where
            application_status_change_id = l_change_id;

        ut.expect(l_changed_at).to_equal(timestamp '2026-01-20 14:00:00 +01:00');
        ut.expect(current_status(l_application_id)).to_equal('INTERVIEWING');
    end correct_latest_date;

    procedure correct_not_latest is

        l_application_id applications.application_id%type;
        l_first_id       application_status_changes.application_status_change_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
    begin
        l_application_id := new_application(
            company_api.create_company('Acme'),
            in_changed_at => systimestamp - interval '1' day
        );

        l_first_id := only_change_id(l_application_id);
        l_change_id := application_api.add_status_change(l_application_id,
                                                         status_id('INTERVIEWING'));
        application_api.correct_latest_status_change(
            in_application_status_change_id => l_first_id,
            in_application_status_id        => status_id('TO_APPLY'),
            in_changed_at                   => systimestamp - interval '1' day,
            in_note_text                    => null
        );

    end correct_not_latest;

    procedure correct_before_previous is
        l_application_id applications.application_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
    begin
        l_application_id := new_application(
            company_api.create_company('Acme'),
            in_changed_at => systimestamp - interval '1' day
        );

        l_change_id := application_api.add_status_change(l_application_id,
                                                         status_id('INTERVIEWING'));
        application_api.correct_latest_status_change(
            in_application_status_change_id => l_change_id,
            in_application_status_id        => status_id('INTERVIEWING'),
            in_changed_at                   => systimestamp - interval '2' day,
            in_note_text                    => null
        );

    end correct_before_previous;

    procedure correct_reopens is

        l_company_id     companies.company_id%type;
        l_application_id applications.application_id%type;
        l_other_id       applications.application_id%type;
    begin
        l_company_id := company_api.create_company('Acme');
        l_application_id := new_application(l_company_id, 'REJECTED');
        l_other_id := new_application(l_company_id);
        application_api.correct_latest_status_change(
            in_application_status_change_id => only_change_id(l_application_id),
            in_application_status_id        => status_id('APPLIED'),
            in_changed_at                   => systimestamp,
            in_note_text                    => null
        );

    end correct_reopens;

    procedure update_status_note_replaces_note is

        l_application_id applications.application_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
        r_before         application_status_changes%rowtype;
        r_after          application_status_changes%rowtype;
    begin
        l_application_id := new_application(company_api.create_company('Acme'));
        l_change_id := application_api.add_status_change(l_application_id,
                                                         status_id('REJECTED'),
                                                         in_note_text => to_clob('Avant'));

        select
            *
        into r_before
        from
            application_status_changes
        where
            application_status_change_id = l_change_id;

        application_api.update_status_note(l_change_id,
                                           to_clob('Profil trop junior'));
        select
            *
        into r_after
        from
            application_status_changes
        where
            application_status_change_id = l_change_id;

        ut.expect(r_after.note_text).to_equal(to_clob('Profil trop junior'));
        ut.expect(r_after.application_status_id).to_equal(r_before.application_status_id);
        ut.expect(r_after.changed_at).to_equal(r_before.changed_at);
    end update_status_note_replaces_note;

    procedure update_status_note_unknown is
    begin
        application_api.update_status_note(co_unknown_id, null);
    end update_status_note_unknown;

    procedure delete_status_change_previous_current is
        l_application_id applications.application_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
    begin
        l_application_id := new_application(
            company_api.create_company('Acme'),
            in_changed_at => systimestamp - interval '1' day
        );

        l_change_id := application_api.add_status_change(l_application_id,
                                                         status_id('INTERVIEWING'));
        application_api.delete_status_change(l_change_id);
        ut.expect(current_status(l_application_id)).to_equal('APPLIED');
    end delete_status_change_previous_current;

    procedure delete_status_change_only_one is
        l_application_id applications.application_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
    begin
        l_application_id := new_application(company_api.create_company('Acme'));
        select
            application_status_change_id
        into l_change_id
        from
            application_status_changes
        where
            application_id = l_application_id;

        application_api.delete_status_change(l_change_id);
    end delete_status_change_only_one;

    procedure delete_status_change_only_one_message is
    begin
        delete_status_change_only_one;
        ut.fail('Suppression du seul statut acceptée');
    exception
        when app_errors.e_protected_row then
            ut.expect(sqlerrm).to_be_like('%« Data engineer »%');
    end delete_status_change_only_one_message;

    procedure delete_status_change_not_latest is

        l_application_id applications.application_id%type;
        l_first_id       application_status_changes.application_status_change_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
    begin
        l_application_id := new_application(
            company_api.create_company('Acme'),
            in_changed_at => systimestamp - interval '2' day
        );

        l_first_id := application_api.add_status_change(l_application_id,
                                                        status_id('INTERVIEWING'),
                                                        systimestamp - interval '1' day);

        l_change_id := application_api.add_status_change(l_application_id,
                                                         status_id('OFFER_RECEIVED'));
        application_api.delete_status_change(l_first_id);
    end delete_status_change_not_latest;

    procedure delete_status_change_unknown is
    begin
        application_api.delete_status_change(co_unknown_id);
    end delete_status_change_unknown;

    procedure delete_status_change_reopens is

        l_company_id     companies.company_id%type;
        l_application_id applications.application_id%type;
        l_other_id       applications.application_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
    begin
        l_company_id := company_api.create_company('Acme');
        l_application_id := new_application(l_company_id,
                                            in_changed_at => systimestamp - interval '2' day);
        l_change_id := application_api.add_status_change(l_application_id,
                                                         status_id('REJECTED'),
                                                         systimestamp - interval '1' day);

        l_other_id := new_application(l_company_id);
        application_api.delete_status_change(l_change_id);
    end delete_status_change_reopens;

    procedure delete_status_change_refused_leaves_nothing is

        l_company_id     companies.company_id%type;
        l_application_id applications.application_id%type;
        l_other_id       applications.application_id%type;
        l_change_id      application_status_changes.application_status_change_id%type;
    begin
        l_company_id := company_api.create_company('Acme');
        l_application_id := new_application(l_company_id,
                                            in_changed_at => systimestamp - interval '2' day);
        l_change_id := application_api.add_status_change(l_application_id,
                                                         status_id('REJECTED'),
                                                         systimestamp - interval '1' day);

        l_other_id := new_application(l_company_id);
        begin
            application_api.delete_status_change(l_change_id);
        exception
            when app_errors.e_duplicate_value then
                null;
        end;
        ut.expect(count_changes(l_application_id)).to_equal(2);
        ut.expect(current_status(l_application_id)).to_equal('REJECTED');
    end delete_status_change_refused_leaves_nothing;

    procedure delete_company_with_applications is
        l_company_id     companies.company_id%type;
        l_application_id applications.application_id%type;
    begin
        l_company_id := company_api.create_company('Acme');
        l_application_id := new_application(l_company_id);
        company_api.delete_company(l_company_id);
    end delete_company_with_applications;

    procedure job_title_required is
        l_application_id applications.application_id%type;
    begin
        l_application_id := application_api.create_application(
            in_company_id            => company_api.create_company('Acme'),
            in_application_type_id   => job_offer_type_id,
            in_job_title             => null,
            in_application_status_id => status_id('APPLIED')
        );
    end job_title_required;

    procedure interest_rating_range is
        l_application_id applications.application_id%type;
    begin
        l_application_id := application_api.create_application(
            in_company_id            => company_api.create_company('Acme'),
            in_application_type_id   => job_offer_type_id,
            in_job_title             => 'Data engineer',
            in_application_status_id => status_id('APPLIED'),
            in_interest_rating       => 6
        );
    end interest_rating_range;

    procedure annual_salary_positive is
        l_application_id applications.application_id%type;
    begin
        l_application_id := application_api.create_application(
            in_company_id                   => company_api.create_company('Acme'),
            in_application_type_id          => job_offer_type_id,
            in_job_title                    => 'Data engineer',
            in_application_status_id        => status_id('APPLIED'),
            in_annual_salary_proposed_euros => - 1
        );
    end annual_salary_positive;

    procedure daily_rate_positive is
        l_application_id applications.application_id%type;
    begin
        l_application_id := application_api.create_application(
            in_company_id                => company_api.create_company('Acme'),
            in_application_type_id       => job_offer_type_id,
            in_job_title                 => 'Data engineer',
            in_application_status_id     => status_id('APPLIED'),
            in_daily_rate_proposed_euros => 0
        );
    end daily_rate_positive;

    procedure changed_at_required is
        l_change_id application_status_changes.application_status_change_id%type;
    begin
        l_change_id := application_api.add_status_change(
            in_application_id        => new_application(company_api.create_company('Acme')),
            in_application_status_id => status_id('INTERVIEWING'),
            in_changed_at            => null
        );
    end changed_at_required;

end test_application_api;
/

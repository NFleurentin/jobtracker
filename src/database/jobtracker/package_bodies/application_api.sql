create or replace package body jobtracker.application_api is

    co_scope constant logger_logs.scope%type := lower($$plsql_unit);

    -- ORA-30006 : délai de FOR UPDATE WAIT dépassé
    e_wait_timeout exception;
    pragma exception_init ( e_wait_timeout, -30006 );

    /**
     * Verrouille une entreprise, pour sérialiser les écritures qui peuvent
     * ouvrir une candidature pour elle.
     * @throws app_errors.co_not_found entreprise inexistante
     * @throws app_errors.co_row_locked entreprise verrouillée par un autre
     *         traitement
     */
    procedure lock_company (
        in_company_id in companies.company_id%type
    ) is
        l_company_id   companies.company_id%type;
        l_company_name companies.company_name%type;
    begin
        -- Attente bornée : un traitement qui garde le verrou (job, script
        -- sans COMMIT) ne doit pas bloquer la page ni sa connexion ORDS.
        -- WAIT n'accepte qu'un littéral : même délai dans lock_application_row
        select
            company_id
        into l_company_id
        from
            companies
        where
            company_id = in_company_id
        for update wait 5;

    exception
        when no_data_found then
            raise_application_error(app_errors.co_not_found, 'Unknown company: ' || in_company_id);
        when e_wait_timeout then
            -- Lecture cohérente, sans verrou : non bloquée
            select
                company_name
            into l_company_name
            from
                companies
            where
                company_id = in_company_id;

            app_message.raise_error(app_errors.co_row_locked, 'COMPANY_LOCKED', l_company_name);
    end lock_company;

    /**
     * Verrouille une candidature, sans son entreprise.
     * @return entreprise de la candidature
     * @throws app_errors.co_not_found candidature inexistante
     * @throws app_errors.co_row_locked candidature verrouillée par un autre
     *         traitement
     */
    function lock_application_row (
        in_application_id in applications.application_id%type
    ) return applications.company_id%type is
        l_company_id applications.company_id%type;
        l_job_title  applications.job_title%type;
    begin
        -- Même délai que lock_company
        select
            company_id
        into l_company_id
        from
            applications
        where
            application_id = in_application_id
        for update wait 5;

        return l_company_id;
    exception
        when no_data_found then
            raise_application_error(app_errors.co_not_found, 'Unknown application: ' || in_application_id);
        when e_wait_timeout then
            select
                job_title
            into l_job_title
            from
                applications
            where
                application_id = in_application_id;

            app_message.raise_error(app_errors.co_row_locked, 'APPLICATION_LOCKED', l_job_title);
    end lock_application_row;

    /**
     * Verrouille une candidature, puis son entreprise.
     * @return entreprise de la candidature
     * @throws app_errors.co_not_found candidature inexistante
     * @throws app_errors.co_row_locked candidature ou entreprise verrouillée
     */
    function lock_application (
        in_application_id in applications.application_id%type
    ) return applications.company_id%type is
        l_company_id applications.company_id%type;
    begin
        l_company_id := lock_application_row(in_application_id);
        lock_company(l_company_id);
        return l_company_id;
    end lock_application;

    /**
     * Candidature d'un changement de statut.
     * @throws app_errors.co_not_found changement inexistant
     */
    function application_of (
        in_application_status_change_id in application_status_changes.application_status_change_id%type
    ) return application_status_changes.application_id%type is
        l_application_id application_status_changes.application_id%type;
    begin
        select
            application_id
        into l_application_id
        from
            application_status_changes
        where
            application_status_change_id = in_application_status_change_id;

        return l_application_id;
    exception
        when no_data_found then
            raise_application_error(app_errors.co_not_found, 'Unknown status change: ' || in_application_status_change_id);
    end application_of;

    /**
     * Changement le plus récent d'une candidature, l'identifiant départageant
     * les égalités de changed_at : même ordre que application_details.
     */
    function latest_change_id (
        in_application_id in applications.application_id%type
    ) return application_status_changes.application_status_change_id%type is
        l_application_status_change_id application_status_changes.application_status_change_id%type;
    begin
        select
            application_status_change_id
        into l_application_status_change_id
        from
            application_status_changes
        where
            application_id = in_application_id
        order by
            changed_at desc,
            application_status_change_id desc
        fetch first 1 row only;

        return l_application_status_change_id;
    end latest_change_id;

    /** Intitulé du poste d'une candidature, pour un message d'erreur métier. */
    function job_title_of (
        in_application_id in applications.application_id%type
    ) return applications.job_title%type is
        l_job_title applications.job_title%type;
    begin
        select
            job_title
        into l_job_title
        from
            applications
        where
            application_id = in_application_id;

        return l_job_title;
    end job_title_of;

    /**
     * Refuse un changement qui n'est pas le plus récent de sa candidature :
     * l'historique antérieur ne se réécrit pas.
     * @throws app_errors.co_protected_row changement antérieur
     */
    procedure check_latest (
        in_application_id               in applications.application_id%type,
        in_application_status_change_id in application_status_changes.application_status_change_id%type
    ) is
    begin
        if in_application_status_change_id <> latest_change_id(in_application_id) then
            app_message.raise_error(app_errors.co_protected_row,
                                    'APPLICATION_STATUS_NOT_LATEST',
                                    job_title_of(in_application_id));
        end if;
    end check_latest;

    /** Met à jour updated_at d'une candidature. */
    procedure touch_application (
        in_application_id in applications.application_id%type
    ) is
    begin
        update applications
        set
            updated_at = systimestamp
        where
            application_id = in_application_id;

    end touch_application;

    /**
     * Refuse plus d'une candidature ouverte pour l'entreprise, l'entreprise
     * générique exceptée. Appelée après l'écriture, sous verrou de
     * l'entreprise : elle voit l'état final, quel que soit le chemin
     * (création, changement d'entreprise, statut ajouté, antidaté, supprimé).
     * @throws app_errors.co_duplicate_value deux candidatures ouvertes
     */
    procedure check_single_open (
        in_company_id in companies.company_id%type
    ) is
        l_open_count   pls_integer;
        l_company_name companies.company_name%type;
    begin
        select
            count(*),
            max(company_name)
        into
            l_open_count,
            l_company_name
        from
            application_details
        where
                company_id = in_company_id
            and is_generic_company = false
            and is_final = false;

        if l_open_count > 1 then
            app_message.raise_error(app_errors.co_duplicate_value, 'APPLICATION_ALREADY_OPEN', l_company_name);
        end if;

    end check_single_open;

    /**
     * Écrit un changement de statut. Ni verrou ni contrôle : ils sont à
     * l'appelant (création de la candidature, ajout d'un statut).
     * @return identifiant du changement
     */
    function insert_status_change (
        in_application_id        in application_status_changes.application_id%type,
        in_application_status_id in application_status_changes.application_status_id%type,
        in_changed_at            in application_status_changes.changed_at%type,
        in_note_text             in application_status_changes.note_text%type
    ) return application_status_changes.application_status_change_id%type is
        l_application_status_change_id application_status_changes.application_status_change_id%type;
    begin
        insert into application_status_changes (
            application_id,
            application_status_id,
            changed_at,
            note_text
        ) values
            ( in_application_id,
              in_application_status_id,
              in_changed_at,
              in_note_text )
        returning application_status_change_id into l_application_status_change_id;

        return l_application_status_change_id;
    end insert_status_change;

    function create_application (
        in_company_id                   in applications.company_id%type,
        in_application_type_id          in applications.application_type_id%type,
        in_job_title                    in applications.job_title%type,
        in_application_status_id        in application_status_changes.application_status_id%type,
        in_changed_at                   in application_status_changes.changed_at%type default systimestamp,
        in_annual_salary_proposed_euros in applications.annual_salary_proposed_euros%type default null,
        in_daily_rate_proposed_euros    in applications.daily_rate_proposed_euros%type default null,
        in_interest_rating              in applications.interest_rating%type default null,
        in_note_text                    in applications.note_text%type default null
    ) return applications.application_id%type is
        l_application_id               applications.application_id%type;
        l_application_status_change_id application_status_changes.application_status_change_id%type;
    begin
        savepoint before_create_application;
        lock_company(in_company_id);
        insert into applications (
            company_id,
            application_type_id,
            job_title,
            annual_salary_proposed_euros,
            daily_rate_proposed_euros,
            interest_rating,
            note_text
        ) values
            ( in_company_id,
              in_application_type_id,
              in_job_title,
              in_annual_salary_proposed_euros,
              in_daily_rate_proposed_euros,
              in_interest_rating,
              in_note_text )
        returning application_id into l_application_id;

        l_application_status_change_id := insert_status_change(l_application_id, in_application_status_id, in_changed_at, null);
        check_single_open(in_company_id);
        return l_application_id;
    exception
        when app_errors.e_duplicate_value then
            rollback to savepoint before_create_application;
            raise;
        when others then
            logger.log_error('Application creation failed', co_scope);
            rollback to savepoint before_create_application;
            raise;
    end create_application;

    procedure update_application (
        in_application_id               in applications.application_id%type,
        in_company_id                   in applications.company_id%type,
        in_application_type_id          in applications.application_type_id%type,
        in_job_title                    in applications.job_title%type,
        in_annual_salary_proposed_euros in applications.annual_salary_proposed_euros%type,
        in_daily_rate_proposed_euros    in applications.daily_rate_proposed_euros%type,
        in_interest_rating              in applications.interest_rating%type,
        in_note_text                    in applications.note_text%type
    ) is
        l_old_company_id applications.company_id%type;
    begin
        savepoint before_update_application;
        -- Candidature d'abord, puis ses deux entreprises par identifiant
        -- croissant
        l_old_company_id := lock_application_row(in_application_id);
        lock_company(least(l_old_company_id, in_company_id));
        if in_company_id <> l_old_company_id then
            lock_company(greatest(l_old_company_id, in_company_id));
        end if;

        update applications
        set
            company_id = in_company_id,
            application_type_id = in_application_type_id,
            job_title = in_job_title,
            annual_salary_proposed_euros = in_annual_salary_proposed_euros,
            daily_rate_proposed_euros = in_daily_rate_proposed_euros,
            interest_rating = in_interest_rating,
            note_text = in_note_text,
            updated_at = systimestamp
        where
            application_id = in_application_id;

        check_single_open(in_company_id);
    exception
        when app_errors.e_duplicate_value then
            rollback to savepoint before_update_application;
            raise;
        when others then
            logger.log_error('Application update failed: ' || in_application_id, co_scope);
            rollback to savepoint before_update_application;
            raise;
    end update_application;

    procedure delete_application (
        in_application_id in applications.application_id%type
    ) is
    begin
        delete from applications
        where
            application_id = in_application_id;

        if sql%rowcount = 0 then
            raise_application_error(app_errors.co_not_found, 'Unknown application: ' || in_application_id);
        end if;

    end delete_application;

    function add_status_change (
        in_application_id        in application_status_changes.application_id%type,
        in_application_status_id in application_status_changes.application_status_id%type,
        in_changed_at            in application_status_changes.changed_at%type default systimestamp,
        in_note_text             in application_status_changes.note_text%type default null
    ) return application_status_changes.application_status_change_id%type is
        l_company_id                   applications.company_id%type;
        l_application_status_change_id application_status_changes.application_status_change_id%type;
    begin
        savepoint before_add_status_change;
        l_company_id := lock_application(in_application_id);
        l_application_status_change_id := insert_status_change(in_application_id, in_application_status_id, in_changed_at, in_note_text
        );
        touch_application(in_application_id);
        check_single_open(l_company_id);
        return l_application_status_change_id;
    exception
        when app_errors.e_duplicate_value then
            rollback to savepoint before_add_status_change;
            raise;
        when others then
            logger.log_error('Status change creation failed: ' || in_application_id, co_scope);
            rollback to savepoint before_add_status_change;
            raise;
    end add_status_change;

    procedure correct_latest_status_change (
        in_application_status_change_id in application_status_changes.application_status_change_id%type,
        in_application_status_id        in application_status_changes.application_status_id%type,
        in_changed_at                   in application_status_changes.changed_at%type,
        in_note_text                    in application_status_changes.note_text%type
    ) is
        l_application_id applications.application_id%type;
        l_company_id     applications.company_id%type;
    begin
        savepoint before_correct_status_change;
        l_application_id := application_of(in_application_status_change_id);
        l_company_id := lock_application(l_application_id);
        check_latest(l_application_id, in_application_status_change_id);
        update application_status_changes
        set
            application_status_id = in_application_status_id,
            changed_at = in_changed_at,
            note_text = in_note_text
        where
            application_status_change_id = in_application_status_change_id;

        -- Une date reculée avant le changement précédent réordonnerait
        -- l'historique
        if in_application_status_change_id <> latest_change_id(l_application_id) then
            app_message.raise_error(app_errors.co_protected_row,
                                    'APPLICATION_STATUS_BEFORE_PREVIOUS',
                                    job_title_of(l_application_id));
        end if;

        touch_application(l_application_id);
        check_single_open(l_company_id);
    exception
        when app_errors.e_duplicate_value or app_errors.e_protected_row then
            rollback to savepoint before_correct_status_change;
            raise;
        when others then
            logger.log_error('Status change correction failed: ' || in_application_status_change_id, co_scope);
            rollback to savepoint before_correct_status_change;
            raise;
    end correct_latest_status_change;

    procedure update_status_note (
        in_application_status_change_id in application_status_changes.application_status_change_id%type,
        in_note_text                    in application_status_changes.note_text%type
    ) is
        l_application_id applications.application_id%type;
    begin
        update application_status_changes
        set
            note_text = in_note_text
        where
            application_status_change_id = in_application_status_change_id
        returning application_id into l_application_id;

        if sql%rowcount = 0 then
            raise_application_error(app_errors.co_not_found, 'Unknown status change: ' || in_application_status_change_id);
        end if;

        touch_application(l_application_id);
    end update_status_note;

    procedure delete_status_change (
        in_application_status_change_id in application_status_changes.application_status_change_id%type
    ) is
        l_application_id applications.application_id%type;
        l_company_id     applications.company_id%type;
        l_change_count   pls_integer;
    begin
        savepoint before_delete_status_change;
        l_application_id := application_of(in_application_status_change_id);
        l_company_id := lock_application(l_application_id);
        select
            count(*)
        into l_change_count
        from
            application_status_changes
        where
            application_id = l_application_id;

        -- Une candidature a toujours un statut : son seul changement ne se
        -- supprime qu'avec elle, ou se corrige
        if l_change_count = 1 then
            app_message.raise_error(app_errors.co_protected_row,
                                    'APPLICATION_LAST_STATUS_UNDELETABLE',
                                    job_title_of(l_application_id));
        end if;

        check_latest(l_application_id, in_application_status_change_id);
        delete from application_status_changes
        where
            application_status_change_id = in_application_status_change_id;

        touch_application(l_application_id);
        check_single_open(l_company_id);
    exception
        when app_errors.e_duplicate_value or app_errors.e_protected_row then
            rollback to savepoint before_delete_status_change;
            raise;
        when others then
            logger.log_error('Status change deletion failed: ' || in_application_status_change_id, co_scope);
            rollback to savepoint before_delete_status_change;
            raise;
    end delete_status_change;

end application_api;
/


-- sqlcl_snapshot {"hash":"4e2f8befe294abdd65381a265c1aee92495d3089","type":"PACKAGE_BODY","name":"APPLICATION_API","schemaName":"JOBTRACKER","sxml":""}
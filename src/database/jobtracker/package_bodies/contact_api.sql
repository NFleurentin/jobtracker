create or replace package body jobtracker.contact_api is

    -- ORA-02292 : suppression d'une ligne parente d'une clé étrangère
    e_child_record_found exception;
    pragma exception_init ( e_child_record_found, -2292 );

    /**
     * Nom d'un contact, pour un message d'erreur métier : l'utilisateur ne
     * voit jamais les identifiants. Guillemets portés par le catalogue.
     */
    function name_of (
        in_contact_id in contacts.contact_id%type
    ) return varchar2 is
        l_contact_name varchar2(201 char);
    begin
        select
            trim(first_name
                 || ' ' || last_name)
        into l_contact_name
        from
            contacts
        where
            contact_id = in_contact_id;

        return l_contact_name;
    end name_of;

    /** Vrai si le contact occupe au moins un poste. */
    function has_positions (
        in_contact_id in contacts.contact_id%type
    ) return boolean is
        l_count pls_integer;
    begin
        select
            count(*)
        into l_count
        from
            contact_positions
        where
                contact_id = in_contact_id
            and rownum = 1;

        return l_count > 0;
    end has_positions;

    function create_contact (
        in_last_name     in contacts.last_name%type,
        in_first_name    in contacts.first_name%type default null,
        in_salutation_id in contacts.salutation_id%type default null,
        in_email         in contacts.email%type default null,
        in_phone         in contacts.phone%type default null,
        in_linkedin_slug in contacts.linkedin_slug%type default null,
        in_note_text     in contacts.note_text%type default null
    ) return contacts.contact_id%type is
        l_contact_id contacts.contact_id%type;
    begin
        insert into contacts (
            last_name,
            first_name,
            salutation_id,
            email,
            phone,
            linkedin_slug,
            note_text
        ) values
            ( in_last_name,
              in_first_name,
              in_salutation_id,
              in_email,
              in_phone,
              in_linkedin_slug,
              in_note_text )
        returning contact_id into l_contact_id;

        return l_contact_id;
    end create_contact;

    procedure update_contact (
        in_contact_id    in contacts.contact_id%type,
        in_last_name     in contacts.last_name%type,
        in_first_name    in contacts.first_name%type,
        in_salutation_id in contacts.salutation_id%type,
        in_email         in contacts.email%type,
        in_phone         in contacts.phone%type,
        in_linkedin_slug in contacts.linkedin_slug%type,
        in_note_text     in contacts.note_text%type
    ) is
    begin
        update contacts
        set
            last_name = in_last_name,
            first_name = in_first_name,
            salutation_id = in_salutation_id,
            email = in_email,
            phone = in_phone,
            linkedin_slug = in_linkedin_slug,
            note_text = in_note_text,
            updated_at = systimestamp
        where
            contact_id = in_contact_id;

        if sql%rowcount = 0 then
            raise_application_error(app_errors.co_not_found, 'Unknown contact: ' || in_contact_id);
        end if;

    end update_contact;

    procedure delete_contact (
        in_contact_id       in contacts.contact_id%type,
        in_delete_positions in boolean default false
    ) is
    begin
        -- Un refus après la suppression des postes doit les rétablir : l'erreur
        -- n'annule que l'instruction en échec
        savepoint before_delete_contact;
        if in_delete_positions then
            delete from contact_positions
            where
                contact_id = in_contact_id;

        elsif has_positions(in_contact_id) then
            app_message.raise_error(app_errors.co_row_referenced,
                                    'CONTACT_HAS_POSITIONS',
                                    name_of(in_contact_id));
        end if;

        delete from contacts
        where
            contact_id = in_contact_id;

        if sql%rowcount = 0 then
            raise_application_error(app_errors.co_not_found, 'Unknown contact: ' || in_contact_id);
        end if;

    exception
        when e_child_record_found then
            rollback to savepoint before_delete_contact;
            app_message.raise_error(app_errors.co_row_referenced,
                                    'CONTACT_ROW_REFERENCED',
                                    name_of(in_contact_id));
    end delete_contact;

    function create_position (
        in_contact_id in contact_positions.contact_id%type,
        in_company_id in contact_positions.company_id%type,
        in_job_id     in contact_positions.job_id%type,
        in_is_current in contact_positions.is_current%type
    ) return contact_positions.contact_position_id%type is
        l_contact_position_id contact_positions.contact_position_id%type;
    begin
        insert into contact_positions (
            contact_id,
            company_id,
            job_id,
            is_current
        ) values
            ( in_contact_id,
              in_company_id,
              in_job_id,
              in_is_current )
        returning contact_position_id into l_contact_position_id;

        return l_contact_position_id;
    end create_position;

    procedure update_position (
        in_contact_position_id in contact_positions.contact_position_id%type,
        in_company_id          in contact_positions.company_id%type,
        in_job_id              in contact_positions.job_id%type,
        in_is_current          in contact_positions.is_current%type
    ) is
    begin
        update contact_positions
        set
            company_id = in_company_id,
            job_id = in_job_id,
            is_current = in_is_current,
            updated_at = systimestamp
        where
            contact_position_id = in_contact_position_id;

        if sql%rowcount = 0 then
            raise_application_error(app_errors.co_not_found, 'Unknown contact position: ' || in_contact_position_id);
        end if;

    end update_position;

    procedure delete_position (
        in_contact_position_id in contact_positions.contact_position_id%type
    ) is
    begin
        delete from contact_positions
        where
            contact_position_id = in_contact_position_id;

        if sql%rowcount = 0 then
            raise_application_error(app_errors.co_not_found, 'Unknown contact position: ' || in_contact_position_id);
        end if;

    end delete_position;

end contact_api;
/


-- sqlcl_snapshot {"hash":"f5bbb3de62b5c45ee886140b81f2ce17235a9065","type":"PACKAGE_BODY","name":"CONTACT_API","schemaName":"JOBTRACKER","sxml":""}
create or replace package body jobtracker.company_api is

    -- ORA-02292 : suppression d'une ligne parente d'une clé étrangère
    e_child_record_found exception;
    pragma exception_init ( e_child_record_found, -2292 );

    /**
     * Nom d'une entreprise, pour un message d'erreur métier : l'utilisateur
     * ne voit jamais les identifiants. Guillemets portés par le catalogue.
     */
    function name_of (
        in_company_id in companies.company_id%type
    ) return companies.company_name%type is
        l_company_name companies.company_name%type;
    begin
        select
            company_name
        into l_company_name
        from
            companies
        where
            company_id = in_company_id;

        return l_company_name;
    end name_of;

    /** Vrai si un contact occupe au moins un poste dans l'entreprise. */
    function has_positions (
        in_company_id in companies.company_id%type
    ) return boolean is
        l_count pls_integer;
    begin
        select
            count(*)
        into l_count
        from
            contact_positions
        where
                company_id = in_company_id
            and rownum = 1;

        return l_count > 0;
    end has_positions;

    /** Vrai pour l'entreprise générique « Confidentielle ». */
    function is_generic (
        in_company_id in companies.company_id%type
    ) return boolean is
        l_count pls_integer;
    begin
        select
            count(*)
        into l_count
        from
            companies
        where
                company_id = in_company_id
            and is_generic = true;

        return l_count > 0;
    end is_generic;

    /**
     * Refuse un parent qui créerait un cycle, l'entreprise elle-même comprise.
     * Remonte la hiérarchie depuis le parent demandé : l'entreprise ne doit pas
     * y figurer. NOCYCLE protège la lecture d'un cycle déjà présent en base.
     * @param in_parent_company_id null : aucun contrôle
     * @throws app_errors.co_circular_reference cycle détecté
     */
    procedure check_no_cycle (
        in_company_id        in companies.company_id%type,
        in_parent_company_id in companies.parent_company_id%type
    ) is
        l_cycle_count pls_integer;
    begin
        select
            count(*)
        into l_cycle_count
        from
            companies
        where
            company_id = in_company_id
        start with
            company_id = in_parent_company_id
        connect by nocycle
            prior parent_company_id = company_id;

        if l_cycle_count > 0 then
            app_message.raise_error(app_errors.co_circular_reference,
                                    'COMPANY_CIRCULAR_REFERENCE',
                                    name_of(in_company_id),
                                    name_of(in_parent_company_id));

        end if;

    end check_no_cycle;

    function create_company (
        in_company_name      in companies.company_name%type,
        in_description       in companies.description%type default null,
        in_note_text         in companies.note_text%type default null,
        in_parent_company_id in companies.parent_company_id%type default null,
        in_company_type_id   in companies.company_type_id%type default null,
        in_sector_id         in companies.sector_id%type default null,
        in_company_size_id   in companies.company_size_id%type default null,
        in_location_id       in companies.location_id%type default null,
        in_siren             in companies.siren%type default null,
        in_website_url       in companies.website_url%type default null,
        in_linkedin_slug     in companies.linkedin_slug%type default null,
        in_email             in companies.email%type default null,
        in_phone             in companies.phone%type default null,
        in_creation_year     in companies.creation_year%type default null
    ) return companies.company_id%type is
        l_company_id companies.company_id%type;
    begin
        insert into companies (
            company_name,
            description,
            note_text,
            parent_company_id,
            company_type_id,
            sector_id,
            company_size_id,
            location_id,
            siren,
            website_url,
            linkedin_slug,
            email,
            phone,
            creation_year
        ) values
            ( in_company_name,
              in_description,
              in_note_text,
              in_parent_company_id,
              in_company_type_id,
              in_sector_id,
              in_company_size_id,
              in_location_id,
              in_siren,
              in_website_url,
              in_linkedin_slug,
              in_email,
              in_phone,
              in_creation_year )
        returning company_id into l_company_id;

        return l_company_id;
    end create_company;

    procedure update_company (
        in_company_id        in companies.company_id%type,
        in_company_name      in companies.company_name%type,
        in_description       in companies.description%type,
        in_note_text         in companies.note_text%type,
        in_parent_company_id in companies.parent_company_id%type,
        in_company_type_id   in companies.company_type_id%type,
        in_sector_id         in companies.sector_id%type,
        in_company_size_id   in companies.company_size_id%type,
        in_location_id       in companies.location_id%type,
        in_siren             in companies.siren%type,
        in_website_url       in companies.website_url%type,
        in_linkedin_slug     in companies.linkedin_slug%type,
        in_email             in companies.email%type,
        in_phone             in companies.phone%type,
        in_creation_year     in companies.creation_year%type
    ) is
    begin
        check_no_cycle(in_company_id, in_parent_company_id);
        update companies
        set
            company_name = in_company_name,
            description = in_description,
            note_text = in_note_text,
            parent_company_id = in_parent_company_id,
            company_type_id = in_company_type_id,
            sector_id = in_sector_id,
            company_size_id = in_company_size_id,
            location_id = in_location_id,
            siren = in_siren,
            website_url = in_website_url,
            linkedin_slug = in_linkedin_slug,
            email = in_email,
            phone = in_phone,
            creation_year = in_creation_year,
            updated_at = systimestamp
        where
            company_id = in_company_id;

        if sql%rowcount = 0 then
            raise_application_error(app_errors.co_not_found, 'Unknown company: ' || in_company_id);
        end if;

    end update_company;

    procedure delete_company (
        in_company_id       in companies.company_id%type,
        in_delete_positions in boolean default false
    ) is
    begin
        if is_generic(in_company_id) then
            app_message.raise_error(app_errors.co_protected_row,
                                    'COMPANY_GENERIC_UNDELETABLE',
                                    name_of(in_company_id));
        end if;

        -- Un refus après la suppression des postes (filiale...) doit les
        -- rétablir : l'erreur n'annule que l'instruction en échec
        savepoint before_delete_company;
        if in_delete_positions then
            delete from contact_positions
            where
                company_id = in_company_id;

        elsif has_positions(in_company_id) then
            app_message.raise_error(app_errors.co_row_referenced,
                                    'COMPANY_HAS_POSITIONS',
                                    name_of(in_company_id));
        end if;

        delete from companies
        where
            company_id = in_company_id;

        if sql%rowcount = 0 then
            raise_application_error(app_errors.co_not_found, 'Unknown company: ' || in_company_id);
        end if;

    exception
        when e_child_record_found then
            rollback to savepoint before_delete_company;
            app_message.raise_error(app_errors.co_row_referenced,
                                    'COMPANY_ROW_REFERENCED',
                                    name_of(in_company_id));
    end delete_company;

end company_api;
/


-- sqlcl_snapshot {"hash":"098ac5d7dfa81e9c84d665bfb4c6dee07a328f28","type":"PACKAGE_BODY","name":"COMPANY_API","schemaName":"JOBTRACKER","sxml":""}
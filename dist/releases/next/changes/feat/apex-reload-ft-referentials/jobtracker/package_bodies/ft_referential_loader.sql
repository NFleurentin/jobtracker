-- liquibase formatted sql
-- changeset JOBTRACKER:1794953099912 stripComments:false  logicalFilePath:feat/apex-reload-ft-referentials/jobtracker/package_bodies/ft_referential_loader.sql
-- sqlcl_snapshot src/database/jobtracker/package_bodies/ft_referential_loader.sql:99e89126cd2f3cc975cb9f090866634f011f8f9c:8ec726d7f0b119787d66eb2569bce368a9e0724b:alter

create or replace package body jobtracker.ft_referential_loader is

    co_scope_prefix   constant varchar2(31 char) := lower($$plsql_unit)
                                                  || '.';

    -- Statuts d'un référentiel dans le détail, et d'un chargement
    co_status_success constant varchar2(10 char) := 'SUCCESS';
    co_status_partial constant varchar2(10 char) := 'PARTIAL';
    co_status_error   constant varchar2(10 char) := 'ERROR';

    -- Job déjà présent : un chargement tourne
    e_job_exists exception;
    pragma exception_init ( e_job_exists, -27477 );
    type t_referentials_type is
        table of varchar2(30 char);

    /**
     * Tous les référentiels, dans l'ordre des clés étrangères : régions,
     * départements, communes, puis les référentiels indépendants.
     */
    function all_referentials return t_referentials_type is
    begin
        return t_referentials_type(co_referential_regions, co_referential_departments, co_referential_communes, co_referential_countries
        , co_referential_continents,
                                   co_referential_contract_types);
    end all_referentials;

    /**
     * Refuse un référentiel inconnu.
     * @throws app_errors.co_not_found référentiel nul ou inconnu
     */
    procedure check_referential (
        in_referential in varchar2
    ) is
    begin
        if in_referential is null
           or in_referential not member of all_referentials then
            raise_application_error(app_errors.co_not_found, 'Unknown France Travail referential: ' || in_referential);
        end if;
    end check_referential;

    /**
     * Référentiels à charger : un seul, ou tous dans l'ordre de chargement.
     * @param in_referential un référentiel ; null pour tous
     * @throws app_errors.co_not_found référentiel inconnu
     */
    function referentials_to_load (
        in_referential in varchar2
    ) return t_referentials_type is
    begin
        if in_referential is null then
            return all_referentials;
        end if;
        check_referential(in_referential);
        return t_referentials_type(in_referential);
    end referentials_to_load;

    /** Endpoint de l'API d'un référentiel. */
    function referential_endpoint (
        in_referential in varchar2
    ) return varchar2 is
    begin
        return
            case in_referential
                when co_referential_regions        then
                    france_travail_api.co_endpoint_ref_regions
                when co_referential_departments    then
                    france_travail_api.co_endpoint_ref_departments
                when co_referential_communes       then
                    france_travail_api.co_endpoint_ref_communes
                when co_referential_countries      then
                    france_travail_api.co_endpoint_ref_countries
                when co_referential_continents     then
                    france_travail_api.co_endpoint_ref_continents
                when co_referential_contract_types then
                    france_travail_api.co_endpoint_ref_contract_types
            end;
    end referential_endpoint;

    /**
     * Table d'un référentiel. Nom tiré de cette seule correspondance, jamais
     * d'une saisie : sûr dans du SQL dynamique.
     */
    function referential_table (
        in_referential in varchar2
    ) return varchar2 is
    begin
        return
            case in_referential
                when co_referential_regions        then
                    'FT_REGIONS'
                when co_referential_departments    then
                    'FT_DEPARTMENTS'
                when co_referential_communes       then
                    'FT_COMMUNES'
                when co_referential_countries      then
                    'FT_COUNTRIES'
                when co_referential_continents     then
                    'FT_CONTINENTS'
                when co_referential_contract_types then
                    'FT_CONTRACT_TYPES'
            end;
    end referential_table;

    /**
     * Contrôle la réponse avant tout MERGE : un tableau vide ferait paraître
     * disparu tout le référentiel.
     * @throws app_errors.co_invalid_response réponse vide, JSON invalide, ou
     *         autre chose qu'un tableau non vide
     */
    procedure check_response (
        in_referential in varchar2,
        in_response    in clob
    ) is
        l_element json_element_t;
    begin
        if in_response is null
           or dbms_lob.getlength(in_response) = 0 then
            raise_application_error(app_errors.co_invalid_response, 'Empty response for referential ' || in_referential);
        end if;

        begin
            l_element := json_element_t.parse(in_response);
        exception
            when others then
                -- Erreur de parsing traduite et relancée, journalisée par l'appelant
                raise_application_error(app_errors.co_invalid_response, 'Invalid JSON for referential '
                                                                        || in_referential
                                                                        || ': '
                                                                        || sqlerrm);
        end;

        if not l_element.is_array then
            raise_application_error(app_errors.co_invalid_response, 'Response is not a JSON array for referential ' || in_referential
            );
        end if;

        if treat(l_element as json_array_t).get_size = 0 then
            raise_application_error(app_errors.co_invalid_response, 'Empty array for referential ' || in_referential);
        end if;

    end check_response;

    /** Régions : code et libellé. */
    procedure merge_regions (
        in_load_id   in ft_referential_loads.ft_referential_load_id%type,
        in_response  in clob,
        out_received out pls_integer
    ) is
    begin
        merge into ft_regions t
        using (
            select
                j.code,
                j.name
            from
                    json_table ( in_response, '$[*]'
                        columns (
                            code varchar2 ( 10 char ) path '$.code',
                            name varchar2 ( 100 char ) path '$.libelle'
                        )
                    )
                j
        ) s on ( t.region_code = s.code )
        when matched then update
        set t.region_name = s.name,
            t.ft_referential_load_id = in_load_id
        when not matched then
        insert (
            region_code,
            region_name,
            ft_referential_load_id )
        values
            ( s.code,
              s.name,
              in_load_id );

        out_received := sql%rowcount;
    end merge_regions;

    /**
     * Départements : région rattachée, nulle si son code est absent de
     * ft_regions (signalé par department_anomalies).
     */
    procedure merge_departments (
        in_load_id   in ft_referential_loads.ft_referential_load_id%type,
        in_response  in clob,
        out_received out pls_integer
    ) is
    begin
        merge into ft_departments t
        using (
            select
                j.code,
                j.name,
                r.region_code
            from
                    json_table ( in_response, '$[*]'
                        columns (
                            code varchar2 ( 10 char ) path '$.code',
                            name varchar2 ( 100 char ) path '$.libelle',
                            region_code varchar2 ( 10 char ) path '$.region.code'
                        )
                    )
                j
                left join ft_regions r on r.region_code = j.region_code
        ) s on ( t.department_code = s.code )
        when matched then update
        set t.department_name = s.name,
            t.region_code = s.region_code,
            t.ft_referential_load_id = in_load_id
        when not matched then
        insert (
            department_code,
            department_name,
            region_code,
            ft_referential_load_id )
        values
            ( s.code,
              s.name,
              s.region_code,
              in_load_id );

        out_received := sql%rowcount;
    end merge_departments;

    /**
     * Communes : département rattaché, nul si son code est absent de
     * ft_departments (signalé par commune_anomalies).
     */
    procedure merge_communes (
        in_load_id   in ft_referential_loads.ft_referential_load_id%type,
        in_response  in clob,
        out_received out pls_integer
    ) is
    begin
        merge into ft_communes t
        using (
            select
                j.code,
                j.name,
                j.postal_code,
                d.department_code
            from
                    json_table ( in_response, '$[*]'
                        columns (
                            code varchar2 ( 10 char ) path '$.code',
                            name varchar2 ( 100 char ) path '$.libelle',
                            postal_code varchar2 ( 10 char ) path '$.codePostal',
                            department_code varchar2 ( 10 char ) path '$.codeDepartement'
                        )
                    )
                j
                left join ft_departments d on d.department_code = j.department_code
        ) s on ( t.commune_code = s.code )
        when matched then update
        set t.commune_name = s.name,
            t.postal_code = s.postal_code,
            t.department_code = s.department_code,
            t.ft_referential_load_id = in_load_id
        when not matched then
        insert (
            commune_code,
            commune_name,
            postal_code,
            department_code,
            ft_referential_load_id )
        values
            ( s.code,
              s.name,
              s.postal_code,
              s.department_code,
              in_load_id );

        out_received := sql%rowcount;
    end merge_communes;

    /** Pays : code et libellé. */
    procedure merge_countries (
        in_load_id   in ft_referential_loads.ft_referential_load_id%type,
        in_response  in clob,
        out_received out pls_integer
    ) is
    begin
        merge into ft_countries t
        using (
            select
                j.code,
                j.name
            from
                    json_table ( in_response, '$[*]'
                        columns (
                            code varchar2 ( 10 char ) path '$.code',
                            name varchar2 ( 100 char ) path '$.libelle'
                        )
                    )
                j
        ) s on ( t.country_code = s.code )
        when matched then update
        set t.country_name = s.name,
            t.ft_referential_load_id = in_load_id
        when not matched then
        insert (
            country_code,
            country_name,
            ft_referential_load_id )
        values
            ( s.code,
              s.name,
              in_load_id );

        out_received := sql%rowcount;
    end merge_countries;

    /** Continents : code et libellé. */
    procedure merge_continents (
        in_load_id   in ft_referential_loads.ft_referential_load_id%type,
        in_response  in clob,
        out_received out pls_integer
    ) is
    begin
        merge into ft_continents t
        using (
            select
                j.code,
                j.name
            from
                    json_table ( in_response, '$[*]'
                        columns (
                            code varchar2 ( 10 char ) path '$.code',
                            name varchar2 ( 100 char ) path '$.libelle'
                        )
                    )
                j
        ) s on ( t.continent_code = s.code )
        when matched then update
        set t.continent_name = s.name,
            t.ft_referential_load_id = in_load_id
        when not matched then
        insert (
            continent_code,
            continent_name,
            ft_referential_load_id )
        values
            ( s.code,
              s.name,
              in_load_id );

        out_received := sql%rowcount;
    end merge_continents;

    /** Types de contrat : code et libellé. */
    procedure merge_contract_types (
        in_load_id   in ft_referential_loads.ft_referential_load_id%type,
        in_response  in clob,
        out_received out pls_integer
    ) is
    begin
        merge into ft_contract_types t
        using (
            select
                j.code,
                j.name
            from
                    json_table ( in_response, '$[*]'
                        columns (
                            code varchar2 ( 10 char ) path '$.code',
                            name varchar2 ( 100 char ) path '$.libelle'
                        )
                    )
                j
        ) s on ( t.contract_type_code = s.code )
        when matched then update
        set t.contract_type_name = s.name,
            t.ft_referential_load_id = in_load_id
        when not matched then
        insert (
            contract_type_code,
            contract_type_name,
            ft_referential_load_id )
        values
            ( s.code,
              s.name,
              in_load_id );

        out_received := sql%rowcount;
    end merge_contract_types;

    /**
     * Départements rattachés à une région absente de ft_regions, par code
     * de région : { parent_code, row_count }.
     */
    function department_anomalies (
        in_response in clob
    ) return json_array_t is
        l_anomalies json_array_t := json_array_t();
        l_anomaly   json_object_t;
    begin
        for r_anomaly in (
            select
                j.region_code,
                count(*) as row_count
            from
                    json_table ( in_response, '$[*]'
                        columns (
                            region_code varchar2 ( 10 char ) path '$.region.code'
                        )
                    )
                j
            where
                j.region_code is not null
                and not exists (
                    select
                        null
                    from
                        ft_regions r
                    where
                        r.region_code = j.region_code
                )
            group by
                j.region_code
            order by
                j.region_code
        ) loop
            l_anomaly := json_object_t();
            l_anomaly.put('parent_code', r_anomaly.region_code);
            l_anomaly.put('row_count', r_anomaly.row_count);
            l_anomalies.append(l_anomaly);
        end loop;

        return l_anomalies;
    end department_anomalies;

    /**
     * Communes rattachées à un département absent de ft_departments, par
     * code de département : { parent_code, row_count }.
     */
    function commune_anomalies (
        in_response in clob
    ) return json_array_t is
        l_anomalies json_array_t := json_array_t();
        l_anomaly   json_object_t;
    begin
        for r_anomaly in (
            select
                j.department_code,
                count(*) as row_count
            from
                    json_table ( in_response, '$[*]'
                        columns (
                            department_code varchar2 ( 10 char ) path '$.codeDepartement'
                        )
                    )
                j
            where
                j.department_code is not null
                and not exists (
                    select
                        null
                    from
                        ft_departments d
                    where
                        d.department_code = j.department_code
                )
            group by
                j.department_code
            order by
                j.department_code
        ) loop
            l_anomaly := json_object_t();
            l_anomaly.put('parent_code', r_anomaly.department_code);
            l_anomaly.put('row_count', r_anomaly.row_count);
            l_anomalies.append(l_anomaly);
        end loop;

        return l_anomalies;
    end commune_anomalies;

    function load_response (
        in_referential in varchar2,
        in_load_id     in ft_referential_loads.ft_referential_load_id%type,
        in_response    in clob
    ) return json_object_t is

        l_table        varchar2(30 char);
        l_result       json_object_t := json_object_t();
        l_last_load_id ft_referential_loads.ft_referential_load_id%type;
        l_received     pls_integer;
        l_dropped      pls_integer := 0;
    begin
        check_referential(in_referential);
        check_response(in_referential, in_response);
        l_table := referential_table(in_referential);

        -- Dernier chargement reçu par ce référentiel, avant celui-ci : ses
        -- codes absents de la réponse deviennent non courants
        execute immediate 'select max(ft_referential_load_id) from ' || l_table
        into l_last_load_id;

        -- Anomalies avant le MERGE, qui met leur rattachement à nul
        case in_referential
            when co_referential_departments then
                l_result.put('anomalies',
                             department_anomalies(in_response));
            when co_referential_communes then
                l_result.put('anomalies',
                             commune_anomalies(in_response));
            else
                null;
        end case;

        case in_referential
            when co_referential_regions then
                merge_regions(in_load_id, in_response, l_received);
            when co_referential_departments then
                merge_departments(in_load_id, in_response, l_received);
            when co_referential_communes then
                merge_communes(in_load_id, in_response, l_received);
            when co_referential_countries then
                merge_countries(in_load_id, in_response, l_received);
            when co_referential_continents then
                merge_continents(in_load_id, in_response, l_received);
            when co_referential_contract_types then
                merge_contract_types(in_load_id, in_response, l_received);
        end case;

        if l_last_load_id <> in_load_id then
            execute immediate 'select count(*) from '
                              || l_table
                              || ' where ft_referential_load_id = :last_load_id'
            into l_dropped
                using l_last_load_id;
        end if;

        l_result.put('received', l_received);
        l_result.put('no_longer_current', l_dropped);
        return l_result;
    end load_response;

    /**
     * Charge un référentiel dans sa propre transaction : appel, MERGE, COMMIT.
     * Un échec est journalisé, annulé jusqu'au savepoint et rendu dans le
     * détail, sans être relancé : les référentiels suivants se chargent.
     * @return détail du référentiel, avec son statut (SUCCESS, ERROR)
     */
    function load_referential (
        in_referential    in varchar2,
        in_load_id        in ft_referential_loads.ft_referential_load_id%type,
        in_correlation_id in raw
    ) return json_object_t is
        l_scope    logger_logs.scope%type := co_scope_prefix || 'load_referential';
        l_response clob;
        l_result   json_object_t;
    begin
        savepoint before_referential;
        l_response := france_travail_api.call(
            in_endpoint       => referential_endpoint(in_referential),
            in_correlation_id => in_correlation_id
        );

        l_result := load_response(in_referential, in_load_id, l_response);
        commit;
        l_result.put('referential', in_referential);
        l_result.put('status', co_status_success);
        return l_result;
    exception
        when others then
            -- Échec consigné dans le chargement, sans relance (voir ci-dessus)
            logger.log_error('Referential '
                             || in_referential
                             || ' failed in load '
                             || in_load_id, l_scope);
            rollback to savepoint before_referential;
            l_result := json_object_t();
            l_result.put('referential', in_referential);
            l_result.put('status', co_status_error);
            l_result.put('error', sqlerrm);
            return l_result;
    end load_referential;

    /** Clôt un chargement : fin, statut et détail, puis COMMIT. */
    procedure close_load (
        in_load_id in ft_referential_loads.ft_referential_load_id%type,
        in_status  in ft_referential_loads.load_status%type,
        in_details in json_object_t
    ) is
        -- Méthode d'objet PL/SQL interdite dans le SQL (ORA-40573)
        l_details json := in_details.to_json;
    begin
        update ft_referential_loads
        set
            ended_at = systimestamp,
            load_status = in_status,
            load_details = l_details
        where
            ft_referential_load_id = in_load_id;

        commit;
    end close_load;

    procedure start_load (
        in_referential in varchar2 default null
    ) is
        l_scope logger_logs.scope%type := co_scope_prefix || 'start_load';
    begin
        if in_referential is not null then
            check_referential(in_referential);
        end if;
        begin
            dbms_scheduler.create_job(
                job_name            => co_job_name,
                job_type            => 'STORED_PROCEDURE',
                job_action          => 'FT_REFERENTIAL_LOADER.RUN_LOAD',
                number_of_arguments => 1,
                enabled             => false,
                auto_drop           => true,
                comments            => 'Chargement ponctuel des référentiels France Travail : ft_referential_loader.run_load'
            );

        exception
            when e_job_exists then
                app_message.raise_error(app_errors.co_already_running, 'FT_REFERENTIAL_LOAD_RUNNING');
        end;

        -- Un job créé mais non activé ne tournerait jamais et bloquerait les
        -- chargements suivants : il est supprimé si la suite échoue
        begin
            dbms_scheduler.set_job_argument_value(
                job_name          => co_job_name,
                argument_position => 1,
                argument_value    => in_referential
            );

            dbms_scheduler.enable(co_job_name);
        exception
            when others then
                logger.log_error('Load job could not be enabled', l_scope);
                dbms_scheduler.drop_job(
                    job_name => co_job_name,
                    force    => true
                );
                raise;
        end;

    end start_load;

    procedure run_load (
        in_referential in varchar2 default null
    ) is

        l_scope          logger_logs.scope%type := co_scope_prefix || 'run_load';
        l_referentials   t_referentials_type := referentials_to_load(in_referential);
        l_correlation_id raw(16) := exchange_log.new_correlation_id;
        l_load_id        ft_referential_loads.ft_referential_load_id%type;
        l_details        json_object_t := json_object_t();
        l_results        json_array_t := json_array_t();
        l_result         json_object_t;
        l_success_count  pls_integer := 0;
        l_status         ft_referential_loads.load_status%type;
    begin
        -- Chargement validé d'emblée : les codes y font référence
        insert into ft_referential_loads ( started_at ) values
            ( systimestamp )
        returning ft_referential_load_id into l_load_id;

        commit;
        logger.log_info('Load '
                        || l_load_id
                        || ' started, correlation_id '
                        || rawtohex(l_correlation_id),
                        l_scope);

        l_details.put('correlation_id',
                      rawtohex(l_correlation_id));
        app_context.set_apex_workspace;
        for i in 1..l_referentials.count loop
            l_result := load_referential(
                l_referentials(i),
                l_load_id,
                l_correlation_id
            );
            l_results.append(l_result);
            if l_result.get_string('status') = co_status_success then
                l_success_count := l_success_count + 1;
            end if;

        end loop;

        l_details.put('referentials', l_results);
        l_status :=
            case l_success_count
                when l_referentials.count then
                    co_status_success
                when 0                    then
                    co_status_error
                else
                    co_status_partial
            end;

        close_load(l_load_id, l_status, l_details);
        logger.log_info('Load '
                        || l_load_id
                        || ' ended: '
                        || l_status, l_scope);
    exception
        when others then
            -- Échec hors d'un référentiel (avant le premier, ou à la clôture)
            logger.log_error('Load '
                             || l_load_id
                             || ' failed', l_scope);
            rollback;
            if l_load_id is not null then
                l_details.put('error', sqlerrm);
                close_load(l_load_id, co_status_error, l_details);
            end if;

            raise;
    end run_load;

    function is_load_running return boolean is
        l_job_count pls_integer;
    begin
        select
            count(*)
        into l_job_count
        from
            user_scheduler_jobs
        where
            job_name = co_job_name;

        return l_job_count > 0;
    end is_load_running;

    function load_state return json_object_t is
        l_state json_object_t := json_object_t();
    begin
        l_state.put('running', is_load_running);
        l_state.put_null('load_id');
        l_state.put_null('load_state');
        l_state.put_null('error_count');
        for r_load in (
            select
                ft_referential_load_id,
                load_state,
                error_count
            from
                ft_referential_load_details
            where
                is_latest
        ) loop
            l_state.put('load_id', r_load.ft_referential_load_id);
            l_state.put('load_state', r_load.load_state);
            l_state.put('error_count', r_load.error_count);
        end loop;

        return l_state;
    end load_state;

end ft_referential_loader;
/


-- liquibase formatted sql
-- changeset JOBTRACKER:1794496660892 stripComments:false  logicalFilePath:feat/purge-external-exchanges/jobtracker/package_bodies/exchange_log.sql
-- sqlcl_snapshot src/database/jobtracker/package_bodies/exchange_log.sql:4fc87397ec2f41d00742313ca3081bc5d13b78de:3bec9758f083e9a9ce8489cd36d7685f8cdf8170:alter

create or replace package body jobtracker.exchange_log is

    co_scope_prefix constant varchar2(31 char) := lower($$plsql_unit)
                                                  || '.';

    /**
     * Identifiant d'un système externe.
     * @throws app_errors.e_not_found code inconnu
     */
    function external_system_id (
        in_code in varchar2
    ) return external_systems.external_system_id%type is
        l_id external_systems.external_system_id%type;
    begin
        select
            external_system_id
        into l_id
        from
            external_systems
        where
            external_system_code = in_code;

        return l_id;
    exception
        when no_data_found then
            raise_application_error(app_errors.co_not_found, 'External system not found: ' || in_code);
    end external_system_id;

    /**
     * Identifiant d'un protocole.
     * @throws app_errors.e_not_found code inconnu
     */
    function exchange_protocol_id (
        in_code in varchar2
    ) return exchange_protocols.exchange_protocol_id%type is
        l_id exchange_protocols.exchange_protocol_id%type;
    begin
        select
            exchange_protocol_id
        into l_id
        from
            exchange_protocols
        where
            exchange_protocol_code = in_code;

        return l_id;
    exception
        when no_data_found then
            raise_application_error(app_errors.co_not_found, 'Exchange protocol not found: ' || in_code);
    end exchange_protocol_id;

    /** Identifiant d'un état, code issu des constantes du package. */
    function exchange_status_id (
        in_code in varchar2
    ) return exchange_statuses.exchange_status_id%type is
        l_id exchange_statuses.exchange_status_id%type;
    begin
        select
            exchange_status_id
        into l_id
        from
            exchange_statuses
        where
            exchange_status_code = in_code;

        return l_id;
    end exchange_status_id;

    function new_correlation_id return raw is
    begin
        return sys_guid();
    end new_correlation_id;

    function open_exchange (
        in_external_system_code   in varchar2,
        in_exchange_protocol_code in varchar2,
        in_request                in json,
        in_correlation_id         in raw default null
    ) return number is

        pragma autonomous_transaction;
        l_scope       logger_logs.scope%type := co_scope_prefix || 'open_exchange';
        l_system_id   external_systems.external_system_id%type;
        l_protocol_id exchange_protocols.exchange_protocol_id%type;
        l_status_id   exchange_statuses.exchange_status_id%type;
        l_id          external_exchanges.external_exchange_id%type;
    begin
        -- Fonctions privées : non appelables depuis l'INSERT (PLS-00231)
        l_system_id := external_system_id(in_external_system_code);
        l_protocol_id := exchange_protocol_id(in_exchange_protocol_code);
        l_status_id := exchange_status_id(co_status_pending);
        insert into external_exchanges (
            external_system_id,
            exchange_protocol_id,
            exchange_status_id,
            correlation_id,
            request,
            started_at,
            app_user,
            apex_session_id,
            db_module,
            db_action,
            db_sid
        ) values
            ( l_system_id,
              l_protocol_id,
              l_status_id,
              in_correlation_id,
              in_request,
              systimestamp,
              -- Hors session APEX (job, script, test) : utilisateur de la base
              coalesce(
                  sys_context('APEX$SESSION', 'APP_USER'),
                  sys_context('USERENV', 'SESSION_USER')
              ),
              to_number(sys_context('APEX$SESSION', 'APP_SESSION')),
              sys_context('USERENV', 'MODULE'),
              sys_context('USERENV', 'ACTION'),
              to_number(sys_context('USERENV', 'SID')) )
        returning external_exchange_id into l_id;

        commit;
        return l_id;
    exception
        when others then
            logger.log_error('Exchange not opened: ' || in_external_system_code, l_scope);
            -- Sans ROLLBACK, ORA-06519 masquerait l'erreur d'origine
            rollback;
            raise;
    end open_exchange;

    /**
     * Clôt un échange PENDING, en transaction autonome.
     * @throws app_errors.e_not_found     échange inconnu
     * @throws app_errors.e_invalid_state échange déjà clos
     */
    procedure close_exchange (
        in_external_exchange_id in number,
        in_status_code          in varchar2,
        in_response             in json,
        in_error_message        in varchar2
    ) is

        pragma autonomous_transaction;
        l_scope       logger_logs.scope%type := co_scope_prefix || 'close_exchange';
        l_status_code exchange_statuses.exchange_status_code%type;
        l_status_id   exchange_statuses.exchange_status_id%type;
    begin
        begin
            select
                s.exchange_status_code
            into l_status_code
            from
                     external_exchanges e
                join exchange_statuses s on s.exchange_status_id = e.exchange_status_id
            where
                e.external_exchange_id = in_external_exchange_id
            for update of e.exchange_status_id;

        exception
            when no_data_found then
                raise_application_error(app_errors.co_not_found, 'Exchange not found: ' || in_external_exchange_id);
        end;

        if l_status_code != co_status_pending then
            raise_application_error(app_errors.co_invalid_state, 'Exchange '
                                                                 || in_external_exchange_id
                                                                 || ' already closed: '
                                                                 || l_status_code);
        end if;

        l_status_id := exchange_status_id(in_status_code);
        update external_exchanges
        set
            exchange_status_id = l_status_id,
            response = in_response,
            error_message = substr(in_error_message, 1, 4000),
            ended_at = systimestamp
        where
            external_exchange_id = in_external_exchange_id;

        commit;
    exception
        when others then
            logger.log_error('Exchange not closed: ' || in_external_exchange_id, l_scope);
            -- Libère le verrou ; sans ROLLBACK, ORA-06519 masquerait l'erreur
            rollback;
            raise;
    end close_exchange;

    procedure complete_exchange (
        in_external_exchange_id in number,
        in_response             in json
    ) is
    begin
        close_exchange(in_external_exchange_id, co_status_completed, in_response, null);
    end complete_exchange;

    procedure fail_exchange (
        in_external_exchange_id in number,
        in_error_message        in varchar2,
        in_response             in json default null
    ) is
    begin
        close_exchange(in_external_exchange_id, co_status_failed, in_response, in_error_message);
    end fail_exchange;

    procedure abandon_orphans is

        l_scope      logger_logs.scope%type := co_scope_prefix || 'abandon_orphans';
        l_pending_id exchange_statuses.exchange_status_id%type := exchange_status_id(co_status_pending);
        l_failed_id  exchange_statuses.exchange_status_id%type := exchange_status_id(co_status_failed);
    begin
        update external_exchanges e
        set
            exchange_status_id = l_failed_id,
            error_message = (
                select
                    'Abandoned: no response after '
                    || s.orphan_delay_minutes
                    || ' minutes'
                from
                    external_systems s
                where
                    s.external_system_id = e.external_system_id
            ),
            ended_at = systimestamp
        where
                e.exchange_status_id = l_pending_id
            and e.started_at < systimestamp - (
                select
                    numtodsinterval(s.orphan_delay_minutes, 'MINUTE')
                from
                    external_systems s
                where
                    s.external_system_id = e.external_system_id
            );

        logger.log_info('Exchanges abandoned: ' || sql%rowcount, l_scope);
    end abandon_orphans;

    procedure delete_expired (
        in_max_rows in pls_integer,
        out_deleted out pls_integer
    ) is
    begin
        delete from external_exchanges e
        where
                e.started_at < systimestamp - (
                    select
                        numtodsinterval(s.retention_days, 'DAY')
                    from
                        external_systems s
                    where
                        s.external_system_id = e.external_system_id
                )
            and rownum <= in_max_rows;

        out_deleted := sql%rowcount;
    end delete_expired;

    procedure run_housekeeping is

        -- Taille d'un lot de suppression : borne l'undo d'une transaction
        co_batch_size constant pls_integer := 10000;
        l_scope       logger_logs.scope%type := co_scope_prefix || 'run_housekeeping';
        l_deleted     pls_integer;
        l_total       pls_integer := 0;
    begin
        -- Suppression d'abord : un PENDING expiré part avec les autres, et
        -- abandon_orphans ne met à jour que des échanges conservés.
        -- Un lot incomplet signale qu'il ne reste rien à supprimer.
        << batches >> loop
            delete_expired(co_batch_size, l_deleted);
            commit;
            l_total := l_total + l_deleted;
            exit batches when l_deleted < co_batch_size;
        end loop batches;

        logger.log_info('Exchanges deleted: ' || l_total, l_scope);
        abandon_orphans;
        commit;
    exception
        when others then
            logger.log_error('Exchange log housekeeping failed', l_scope);
            rollback;
            raise;
    end run_housekeeping;

end exchange_log;
/


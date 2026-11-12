create or replace package body jobtracker.test_exchange_log is

    -- Échanges créés par le test en cours, supprimés par cleanup
    g_exchange_ids sys.odcinumberlist := sys.odcinumberlist();

    /** Ouvre un échange HTTP France Travail et le retient pour cleanup. */
    function open_test_exchange (
        in_correlation_id in raw default null
    ) return number is
        l_id external_exchanges.external_exchange_id%type;
    begin
        l_id := exchange_log.open_exchange(
            in_external_system_code   => exchange_log.co_system_france_travail,
            in_exchange_protocol_code => exchange_log.co_protocol_http,
            in_request                =>
                        json(
                            '{"url":"https://test.invalid/","method":"GET","headers":[],"body":null}'
                        ),
            in_correlation_id         => in_correlation_id
        );

        g_exchange_ids.extend;
        g_exchange_ids(g_exchange_ids.count) := l_id;
        return l_id;
    end open_test_exchange;

    /** Code de l'état courant d'un échange. */
    function status_code (
        in_external_exchange_id in number
    ) return varchar2 is
        l_code exchange_statuses.exchange_status_code%type;
    begin
        select
            s.exchange_status_code
        into l_code
        from
                 external_exchanges e
            join exchange_statuses s on s.exchange_status_id = e.exchange_status_id
        where
            e.external_exchange_id = in_external_exchange_id;

        return l_code;
    end status_code;

    procedure cleanup is
        pragma autonomous_transaction;
    begin
        delete from external_exchanges
        where
            external_exchange_id in (
                select
                    column_value
                from
                    table ( g_exchange_ids )
            );

        commit;
        g_exchange_ids.delete;
    end cleanup;

    procedure reference_codes_loaded is
        l_count pls_integer;
    begin
        select
            count(*)
        into l_count
        from
            external_systems
        where
            external_system_code = exchange_log.co_system_france_travail;

        ut.expect(l_count).to_equal(1);
        select
            count(*)
        into l_count
        from
            exchange_protocols
        where
            exchange_protocol_code = exchange_log.co_protocol_http;

        ut.expect(l_count).to_equal(1);
        select
            count(*)
        into l_count
        from
            exchange_statuses
        where
            exchange_status_code in ( exchange_log.co_status_pending, exchange_log.co_status_completed, exchange_log.co_status_failed
            );

        ut.expect(l_count).to_equal(3);
    end reference_codes_loaded;

    procedure new_correlation_id_unique is

        l_first  raw(16) := exchange_log.new_correlation_id;
        l_second raw(16) := exchange_log.new_correlation_id;
    begin
        ut.expect(utl_raw.length(l_first)).to_equal(16);
        ut.expect(l_first).not_to_equal(l_second);
    end new_correlation_id_unique;

    procedure open_exchange_pending is

        l_correlation_id raw(16) := exchange_log.new_correlation_id;
        l_id             external_exchanges.external_exchange_id%type;
        r_exchange       external_exchanges%rowtype;
    begin
        l_id := open_test_exchange(l_correlation_id);
        select
            *
        into r_exchange
        from
            external_exchanges
        where
            external_exchange_id = l_id;

        ut.expect(status_code(l_id)).to_equal(exchange_log.co_status_pending);
        ut.expect(r_exchange.correlation_id).to_equal(l_correlation_id);
        ut.expect(json_value(r_exchange.request, '$.url')).to_equal('https://test.invalid/');

        ut.expect(r_exchange.started_at).to_be_not_null();
        ut.expect(r_exchange.ended_at).to_be_null();
        ut.expect(r_exchange.response is null).to_be_true();
        -- Hors session APEX : repli sur l'utilisateur de la base
        ut.expect(r_exchange.app_user).to_equal(sys_context('USERENV', 'SESSION_USER'));

        ut.expect(r_exchange.db_sid).to_equal(to_number(sys_context('USERENV', 'SID')));

    end open_exchange_pending;

    procedure open_exchange_survives_rollback is
        l_id    external_exchanges.external_exchange_id%type;
        l_count pls_integer;
    begin
        l_id := open_test_exchange;
        rollback;
        select
            count(*)
        into l_count
        from
            external_exchanges
        where
            external_exchange_id = l_id;

        ut.expect(l_count).to_equal(1);
    end open_exchange_survives_rollback;

    procedure open_exchange_unknown_system is
        l_id external_exchanges.external_exchange_id%type;
    begin
        l_id := exchange_log.open_exchange(
            in_external_system_code   => 'UNKNOWN_SYSTEM',
            in_exchange_protocol_code => exchange_log.co_protocol_http,
            in_request                =>
                        json(
                            '{}'
                        )
        );
    end open_exchange_unknown_system;

    procedure open_exchange_unknown_protocol is
        l_id external_exchanges.external_exchange_id%type;
    begin
        l_id := exchange_log.open_exchange(
            in_external_system_code   => exchange_log.co_system_france_travail,
            in_exchange_protocol_code => 'UNKNOWN_PROTOCOL',
            in_request                =>
                        json(
                            '{}'
                        )
        );
    end open_exchange_unknown_protocol;

    procedure complete_exchange_stores_response is
        l_id       external_exchanges.external_exchange_id%type;
        r_exchange external_exchanges%rowtype;
    begin
        l_id := open_test_exchange;
        exchange_log.complete_exchange(l_id,
                                       json(
                                  '{"status_code":404,"headers":[],"body":"Not found"}'
                              )
        );
        select
            *
        into r_exchange
        from
            external_exchanges
        where
            external_exchange_id = l_id;

        -- Une réponse d'erreur HTTP reste un échange abouti
        ut.expect(status_code(l_id)).to_equal(exchange_log.co_status_completed);
        ut.expect(json_value(r_exchange.response, '$.status_code' returning number)).to_equal(404);
        ut.expect(r_exchange.ended_at).to_be_not_null();
        ut.expect(r_exchange.error_message).to_be_null();
    end complete_exchange_stores_response;

    procedure fail_exchange_stores_error is
        l_id       external_exchanges.external_exchange_id%type;
        r_exchange external_exchanges%rowtype;
    begin
        l_id := open_test_exchange;
        exchange_log.fail_exchange(l_id, 'ORA-29276: transfer timeout');
        select
            *
        into r_exchange
        from
            external_exchanges
        where
            external_exchange_id = l_id;

        ut.expect(status_code(l_id)).to_equal(exchange_log.co_status_failed);
        ut.expect(r_exchange.error_message).to_equal('ORA-29276: transfer timeout');
        ut.expect(r_exchange.response is null).to_be_true();
        ut.expect(r_exchange.ended_at).to_be_not_null();
    end fail_exchange_stores_error;

    procedure close_exchange_twice is
        l_id external_exchanges.external_exchange_id%type;
    begin
        l_id := open_test_exchange;
        exchange_log.complete_exchange(l_id,
                                       json(
                                  '{"status_code":200,"headers":[],"body":null}'
                              )
        );
        exchange_log.fail_exchange(l_id, 'Second close');
    end close_exchange_twice;

    procedure close_exchange_unknown is
    begin
        exchange_log.complete_exchange(-1,
                                       json(
                                  '{"status_code":200,"headers":[],"body":null}'
                              )
        );
    end close_exchange_unknown;

end test_exchange_log;
/

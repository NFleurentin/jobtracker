create or replace package body jobtracker.test_external_exchange_name_values is

    co_request constant varchar2(4000 char) := '{"url":"https://test.invalid/search","method":"GET",'
                                               || '"params":[{"name":"motsCles","value":"data"},{"name":"range","value":"0-149"}],'
                                               || '"headers":[{"name":"Authorization","value":"***"}],"body":null}';

    /**
     * Ajoute un échange France Travail directement dans la table, sans passer
     * par exchange_log.
     * @param in_response null pour un échange en cours
     * @return identifiant de l'échange
     */
    function add_exchange (
        in_request       in varchar2 default co_request,
        in_response      in varchar2 default null,
        in_protocol_code in exchange_protocols.exchange_protocol_code%type default exchange_log.co_protocol_http
    ) return external_exchanges.external_exchange_id%type is

        l_system_id   external_systems.external_system_id%type;
        l_protocol_id exchange_protocols.exchange_protocol_id%type;
        l_status_id   exchange_statuses.exchange_status_id%type;
        l_id          external_exchanges.external_exchange_id%type;
    begin
        select
            external_system_id
        into l_system_id
        from
            external_systems
        where
            external_system_code = exchange_log.co_system_france_travail;

        select
            exchange_protocol_id
        into l_protocol_id
        from
            exchange_protocols
        where
            exchange_protocol_code = in_protocol_code;

        select
            exchange_status_id
        into l_status_id
        from
            exchange_statuses
        where
            exchange_status_code = case
                                       when in_response is null then
                                           exchange_log.co_status_pending
                                       else
                                           exchange_log.co_status_completed
                                   end;

        insert into external_exchanges (
            external_system_id,
            exchange_protocol_id,
            exchange_status_id,
            request,
            response,
            started_at,
            ended_at,
            app_user
        ) values
            ( l_system_id,
              l_protocol_id,
              l_status_id,
              json(
                    in_request
                ),
              json(
                    in_response
                ),
              systimestamp,
              case
                  when in_response is not null then
                        systimestamp
              end,
              'TEST' )
        returning external_exchange_id into l_id;

        return l_id;
    end add_exchange;

    /** Nombre de paires d'un échange, pour une enveloppe et un type. */
    function count_pairs (
        in_external_exchange_id in external_exchanges.external_exchange_id%type,
        in_envelope             in varchar2 default null,
        in_field_type           in varchar2 default null
    ) return pls_integer is
        l_count pls_integer;
    begin
        select
            count(*)
        into l_count
        from
            external_exchange_name_values
        where
                external_exchange_id = in_external_exchange_id
            and envelope = coalesce(in_envelope, envelope)
            and field_type = coalesce(in_field_type, field_type);

        return l_count;
    end count_pairs;

    procedure split_by_envelope_and_type is
        l_id external_exchanges.external_exchange_id%type;
    begin
        l_id := add_exchange(in_response => '{"status_code":200,"headers":[{"name":"Content-Type","value":"application/json"},' || '{"name":"Content-Range","value":"offres 0-149/2000"}],"body":null}'
        );
        ut.expect(count_pairs(l_id, 'REQUEST', 'PARAM')).to_equal(2);

        ut.expect(count_pairs(l_id, 'REQUEST', 'HEADER')).to_equal(1);

        ut.expect(count_pairs(l_id, 'RESPONSE', 'HEADER')).to_equal(2);

        ut.expect(count_pairs(l_id, 'RESPONSE', 'PARAM')).to_equal(0);

    end split_by_envelope_and_type;

    procedure keeps_order_and_repeated_names is
        l_id       external_exchanges.external_exchange_id%type;
        l_actual   sys_refcursor;
        l_expected sys_refcursor;
    begin
        l_id := add_exchange(in_request => '{"url":"https://test.invalid/","method":"GET",'
                                           || '"params":[{"name":"b","value":"1"},{"name":"a","value":"2"},{"name":"b","value":"3"}],'
                                           || '"headers":[],"body":null}');
        open l_actual for select
            field_position,
            field_name,
            field_value
        from
            external_exchange_name_values
        where
                external_exchange_id = l_id
            and field_type = 'PARAM'
        order by
            field_position;

        open l_expected for select
            1   as field_position,
            'b' as field_name,
            '1' as field_value
        from
            dual
        union all
        select
            2,
            'a',
            '2'
        from
            dual
        union all
        select
            3,
            'b',
            '3'
        from
            dual;

        ut.expect(l_actual).to_equal(l_expected);
    end keeps_order_and_repeated_names;

    procedure pending_without_response_headers is
        l_id external_exchanges.external_exchange_id%type;
    begin
        l_id := add_exchange;
        ut.expect(count_pairs(l_id, 'REQUEST')).to_equal(3);
        ut.expect(count_pairs(l_id, 'RESPONSE')).to_equal(0);
    end pending_without_response_headers;

    procedure other_protocol_without_rows is
        l_id external_exchanges.external_exchange_id%type;
    begin
        -- Protocole fictif, annulé avec le test
        insert into exchange_protocols (
            exchange_protocol_code,
            exchange_protocol_name_fr,
            exchange_protocol_name_en
        ) values
            ( 'TEST_PROTOCOL',
              'Protocole de test',
              'Test protocol' );

        l_id := add_exchange(in_protocol_code => 'TEST_PROTOCOL');
        ut.expect(count_pairs(l_id)).to_equal(0);
    end other_protocol_without_rows;

end test_external_exchange_name_values;
/

create or replace package body jobtracker.test_external_exchange_details is

    co_request constant varchar2(100 char) := '{"url":"https://test.invalid/search","method":"GET","params":[],"headers":[],"body":null}'
    ;

    /** Identifiant d'un protocole, par son code. */
    function protocol_id (
        in_code in exchange_protocols.exchange_protocol_code%type
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
    end protocol_id;

    /**
     * Ajoute un échange France Travail directement dans la table : fixe
     * l'état, les dates et les enveloppes sans passer par exchange_log.
     * @return identifiant de l'échange
     */
    function add_exchange (
        in_status_code   in exchange_statuses.exchange_status_code%type,
        in_request       in varchar2 default co_request,
        in_response      in varchar2 default null,
        in_started_at    in external_exchanges.started_at%type default systimestamp,
        in_ended_at      in external_exchanges.ended_at%type default null,
        in_protocol_code in exchange_protocols.exchange_protocol_code%type default exchange_log.co_protocol_http
    ) return external_exchanges.external_exchange_id%type is

        l_system_id   external_systems.external_system_id%type;
        l_protocol_id exchange_protocols.exchange_protocol_id%type := protocol_id(in_protocol_code);
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
            exchange_status_id
        into l_status_id
        from
            exchange_statuses
        where
            exchange_status_code = in_status_code;

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
              in_started_at,
              in_ended_at,
              'TEST' )
        returning external_exchange_id into l_id;

        return l_id;
    end add_exchange;

    /** Ligne de la vue pour l'échange donné. */
    function get_details (
        in_external_exchange_id in external_exchanges.external_exchange_id%type
    ) return external_exchange_details%rowtype is
        r_details external_exchange_details%rowtype;
    begin
        select
            *
        into r_details
        from
            external_exchange_details
        where
            external_exchange_id = in_external_exchange_id;

        return r_details;
    end get_details;

    procedure http_fields_extracted is
        r_details external_exchange_details%rowtype;
    begin
        r_details := get_details(add_exchange(
            in_status_code => exchange_log.co_status_completed,
            in_response    => '{"status_code":503,"headers":[],"body":"Service Unavailable"}',
            in_ended_at    => systimestamp
        ));

        ut.expect(r_details.request_method).to_equal('GET');
        ut.expect(r_details.request_url).to_equal('https://test.invalid/search');
        ut.expect(r_details.response_status_code).to_equal(503);
    end http_fields_extracted;

    procedure pending_without_response is
        r_details external_exchange_details%rowtype;
    begin
        r_details := get_details(add_exchange(in_status_code => exchange_log.co_status_pending));
        ut.expect(r_details.request_method).to_equal('GET');
        ut.expect(r_details.response_status_code).to_be_null();
        ut.expect(r_details.duration_seconds).to_be_null();
    end pending_without_response;

    procedure duration_in_seconds is
        l_started_at external_exchanges.started_at%type := systimestamp;
        r_details    external_exchange_details%rowtype;
    begin
        -- Plus d'une minute, pour couvrir chaque composante de l'intervalle
        r_details := get_details(add_exchange(
            in_status_code => exchange_log.co_status_completed,
            in_response    => '{"status_code":200,"headers":[],"body":null}',
            in_started_at  => l_started_at,
            in_ended_at    => l_started_at + interval '0 01:02:03.25' day to second
        ));

        ut.expect(r_details.duration_seconds).to_equal(3723.25);
    end duration_in_seconds;

    procedure other_protocol_without_http_fields is
        r_details external_exchange_details%rowtype;
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

        r_details := get_details(add_exchange(
            in_status_code   => exchange_log.co_status_completed,
            in_response      => '{"status_code":200}',
            in_ended_at      => systimestamp,
            in_protocol_code => 'TEST_PROTOCOL'
        ));

        ut.expect(r_details.request_method).to_be_null();
        ut.expect(r_details.request_url).to_be_null();
        ut.expect(r_details.response_status_code).to_be_null();
    end other_protocol_without_http_fields;

    procedure malformed_status_code_is_null is
        r_details external_exchange_details%rowtype;
    begin
        r_details := get_details(add_exchange(
            in_status_code => exchange_log.co_status_completed,
            in_response    => '{"status_code":"n/a","headers":[],"body":null}',
            in_ended_at    => systimestamp
        ));

        ut.expect(r_details.response_status_code).to_be_null();
    end malformed_status_code_is_null;

    procedure json_body_pretty is
        r_details external_exchange_details%rowtype;
    begin
        r_details := get_details(add_exchange(
            in_status_code => exchange_log.co_status_completed,
            in_response    => '{"status_code":200,"headers":[],"body":{"total":2}}',
            in_ended_at    => systimestamp
        ));

        -- Indenté : la paire est sur sa propre ligne
        ut.expect(r_details.response_body).to_be_like('{%'
                                                      || chr(10) || '%"total" : 2%}');

    end json_body_pretty;

    procedure text_body_as_is is
        r_details external_exchange_details%rowtype;
    begin
        r_details := get_details(add_exchange(
            in_status_code => exchange_log.co_status_completed,
            in_response    => '{"status_code":502,"headers":[],"body":"<html>Bad Gateway</html>"}',
            in_ended_at    => systimestamp
        ));

        ut.expect(r_details.response_body).to_equal(to_clob('<html>Bad Gateway</html>'));
    end text_body_as_is;

    procedure null_body_is_null is
        r_details external_exchange_details%rowtype;
    begin
        r_details := get_details(add_exchange(in_status_code => exchange_log.co_status_pending));
        ut.expect(r_details.request_body).to_be_null();
    end null_body_is_null;

    procedure labels_in_french is
        r_details external_exchange_details%rowtype;
    begin
        r_details := get_details(add_exchange(in_status_code => exchange_log.co_status_pending));
        ut.expect(r_details.external_system_name).to_equal('France Travail');
        ut.expect(r_details.exchange_protocol_name).to_equal('HTTP');
        ut.expect(r_details.exchange_status_name).to_equal('En cours');
    end labels_in_french;

    procedure labels_in_english_session is
        r_details external_exchange_details%rowtype;
    begin
        r_details := get_details(add_exchange(in_status_code => exchange_log.co_status_pending));
        ut.expect(r_details.exchange_status_name).to_equal('Pending');
    end labels_in_english_session;

end test_external_exchange_details;
/

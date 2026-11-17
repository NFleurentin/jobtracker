create or replace package body jobtracker.test_ft_referential_load_details is

    /** Insère un chargement et rend son identifiant ; non terminé si le statut est nul. */
    function insert_load (
        in_load_status  in ft_referential_loads.load_status%type default null,
        in_load_details in varchar2 default null
    ) return ft_referential_loads.ft_referential_load_id%type is
        l_load_id ft_referential_loads.ft_referential_load_id%type;
    begin
        insert into ft_referential_loads (
            ended_at,
            load_status,
            load_details
        ) values
            (
                case
                    when in_load_status is not null then
                        systimestamp
                end,
                in_load_status,
                json(
                    in_load_details
                )
            )
        returning ft_referential_load_id into l_load_id;

        return l_load_id;
    end insert_load;

    /** État d'un chargement dans la vue. */
    function load_state (
        in_load_id in ft_referential_loads.ft_referential_load_id%type
    ) return varchar2 is
        l_load_state varchar2(30 char);
    begin
        select
            load_state
        into l_load_state
        from
            ft_referential_load_details
        where
            ft_referential_load_id = in_load_id;

        return l_load_state;
    end load_state;

    procedure ended_load_status is
    begin
        ut.expect(load_state(insert_load('PARTIAL'))).to_equal('PARTIAL');
    end ended_load_status;

    procedure latest_unfinished_interrupted is
    begin
        ut.expect(load_state(insert_load)).to_equal('INTERRUPTED');
    end latest_unfinished_interrupted;

    procedure older_unfinished_interrupted is
        l_load_id ft_referential_loads.ft_referential_load_id%type;
    begin
        l_load_id := insert_load;
        ut.expect(load_state(insert_load('SUCCESS'))).to_equal('SUCCESS');
        ut.expect(load_state(l_load_id)).to_equal('INTERRUPTED');
    end older_unfinished_interrupted;

    procedure errors_counted is
        l_load_id     ft_referential_loads.ft_referential_load_id%type;
        l_error_count pls_integer;
    begin
        l_load_id := insert_load('PARTIAL', '{"referentials":[{"referential":"REGIONS","status":"ERROR"},'
                                            || '{"referential":"COMMUNES","status":"SUCCESS"},'
                                            || '{"referential":"COUNTRIES","status":"ERROR"}]}');
        select
            error_count
        into l_error_count
        from
            ft_referential_load_details
        where
            ft_referential_load_id = l_load_id;

        ut.expect(l_error_count).to_equal(2);
    end errors_counted;

    procedure no_referentials_no_error is
        l_load_id     ft_referential_loads.ft_referential_load_id%type;
        l_error_count pls_integer;
    begin
        l_load_id := insert_load('ERROR', '{"error":"ORA-00000"}');
        select
            error_count
        into l_error_count
        from
            ft_referential_load_details
        where
            ft_referential_load_id = l_load_id;

        ut.expect(l_error_count).to_equal(0);
    end no_referentials_no_error;

    procedure only_latest_marked is
        l_load_id   ft_referential_loads.ft_referential_load_id%type;
        l_latest_id ft_referential_loads.ft_referential_load_id%type;
    begin
        l_load_id := insert_load('SUCCESS');
        select
            ft_referential_load_id
        into l_latest_id
        from
            ft_referential_load_details
        where
            is_latest;

        ut.expect(l_latest_id).to_equal(l_load_id);
    end only_latest_marked;

end test_ft_referential_load_details;
/

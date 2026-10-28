create or replace package body jobtracker.test_collect_staging is

    co_source_code constant offer_sources.source_code%type := 'FRANCE_TRAVAIL';

    /** Run RUNNING de test, sur la source de référence. */
    function new_run return collect_runs.run_id%type is
    begin
        return collect_staging.open_run(co_source_code,
                                        json(
                                        '{"motsCles":"test"}'
                                    )
        );
    end new_run;

    /** Requête ouverte de test, rattachée au run donné. */
    function new_request (
        in_run_id in collect_runs.run_id%type
    ) return collect_requests.request_id%type is
    begin
        return collect_staging.open_request(in_run_id, 'GET', 'https://example.test/offres', null);
    end new_request;

    procedure open_run_creates_running_run is
        l_run_id collect_runs.run_id%type;
        r_run    collect_runs%rowtype;
    begin
        l_run_id := new_run;
        select
         *
        into r_run
        from
            collect_runs
        where
            run_id = l_run_id;

        ut.expect(r_run.status).to_equal(collect_staging.co_status_running);
        ut.expect(r_run.ended_at).to_be_null();
        ut.expect(json_value(r_run.search_params, '$.motsCles')).to_equal('test');

    end open_run_creates_running_run;

    procedure open_run_unknown_source is
        l_run_id collect_runs.run_id%type;
    begin
        l_run_id := collect_staging.open_run('UNKNOWN', null);
    end open_run_unknown_source;

    procedure close_run_sets_status is
        l_run_id collect_runs.run_id%type;
        r_run    collect_runs%rowtype;
    begin
        l_run_id := new_run;
        collect_staging.close_run(l_run_id, collect_staging.co_status_failed, 150, 'HTTP 500');
        select
         *
        into r_run
        from
            collect_runs
        where
            run_id = l_run_id;

        ut.expect(r_run.status).to_equal(collect_staging.co_status_failed);
        ut.expect(r_run.ended_at).not_to_be_null();
        ut.expect(r_run.received_offer_count).to_equal(150);
        ut.expect(r_run.error_message).to_equal('HTTP 500');
    end close_run_sets_status;

    procedure close_run_already_closed is
        l_run_id collect_runs.run_id%type;
    begin
        l_run_id := new_run;
        collect_staging.close_run(l_run_id, collect_staging.co_status_succeeded, 0);
        collect_staging.close_run(l_run_id, collect_staging.co_status_failed);
    end close_run_already_closed;

    procedure open_request_numbers_requests is

        l_run_id     collect_runs.run_id%type;
        l_request_id collect_requests.request_id%type;
        l_seqs       varchar2(100 char);
        l_seq        collect_requests.request_seq%type;
    begin
        l_run_id := new_run;
        l_request_id := new_request(l_run_id);
        l_request_id := new_request(l_run_id);
        select
            listagg(request_seq, ',') within group(
            order by
                request_id
            )
        into l_seqs
        from
            collect_requests
        where
            run_id = l_run_id;

        ut.expect(l_seqs).to_equal('1,2');

        -- Numérotation propre à chaque run
        l_request_id := new_request(new_run);
        select
            request_seq
        into l_seq
        from
            collect_requests
        where
            request_id = l_request_id;

        ut.expect(l_seq).to_equal(1);
    end open_request_numbers_requests;

    procedure close_request_json_body is
        l_request_id collect_requests.request_id%type;
        r_request    collect_requests%rowtype;
    begin
        l_request_id := new_request(new_run);
        collect_staging.close_request(l_request_id,
                                      206,
                                      json(
                              '{"Content-Range":"offres 0-149/2345"}'
                          ),
                                      '{"resultats":[{"id":"1"}]}');
        select
         *
        into r_request
        from
            collect_requests
        where
            request_id = l_request_id;

        ut.expect(r_request.response_code).to_equal(206);
        ut.expect(r_request.ended_at).not_to_be_null();
        ut.expect(json_value(r_request.response_payload_json, '$.resultats[0].id')).to_equal('1');

        ut.expect(json_value(r_request.response_headers, '$."Content-Range"')).to_equal('offres 0-149/2345');

        ut.expect(r_request.error_message).to_be_null();
    end close_request_json_body;

    procedure close_request_non_json_body is
        l_request_id collect_requests.request_id%type;
        r_request    collect_requests%rowtype;
    begin
        l_request_id := new_request(new_run);
        collect_staging.close_request(l_request_id, 502, null, '<html>Bad Gateway</html>', 'HTTP 502');
        select
         *
        into r_request
        from
            collect_requests
        where
            request_id = l_request_id;

        ut.expect(r_request.response_payload_json).to_be_null();
        ut.expect(r_request.error_message).to_equal('HTTP 502'
                                                    || chr(10) || '<html>Bad Gateway</html>');

    end close_request_non_json_body;

    procedure close_request_empty_body is
        l_request_id collect_requests.request_id%type;
        r_request    collect_requests%rowtype;
    begin
        l_request_id := new_request(new_run);
        collect_staging.close_request(l_request_id, 204, null, null);
        select
         *
        into r_request
        from
            collect_requests
        where
            request_id = l_request_id;

        ut.expect(r_request.response_code).to_equal(204);
        ut.expect(r_request.response_payload_json).to_be_null();
        ut.expect(r_request.error_message).to_be_null();
    end close_request_empty_body;

    procedure close_request_truncates_body is
        l_request_id collect_requests.request_id%type;
        l_body       clob;
        r_request    collect_requests%rowtype;
    begin
        l_request_id := new_request(new_run);
        -- 10 000 caractères accentués (2 octets chacun en UTF-8)
        dbms_lob.createtemporary(l_body, true);
        for i in 1..10 loop
            dbms_lob.append(l_body,
                            rpad('é', 1000, 'é'));
        end loop;

        collect_staging.close_request(l_request_id, 502, null, l_body);
        select
         *
        into r_request
        from
            collect_requests
        where
            request_id = l_request_id;

        ut.expect(lengthb(r_request.error_message)).to_be_less_or_equal(4000);
        ut.expect(r_request.error_message).to_be_like('ééé%');
    end close_request_truncates_body;

    procedure close_request_unknown_request is
    begin
        collect_staging.close_request(-1, 200, null, null);
    end close_request_unknown_request;

end test_collect_staging;
/

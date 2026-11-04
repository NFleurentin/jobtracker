create or replace package body jobtracker.test_helpers is

    procedure start_english_session is
        pragma autonomous_transaction;
    begin
        apex_session.create_session(
            p_app_id   => 1000,
            p_page_id  => 1,
            p_username => 'TEST'
        );
        apex_util.set_session_lang('en');
        commit;
    end start_english_session;

    procedure end_english_session is
        pragma autonomous_transaction;
    begin
        apex_session.detach;
    end end_english_session;

end test_helpers;
/

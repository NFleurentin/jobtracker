create or replace package body jobtracker.test_http_util is

    procedure is_server_error_bounds is
    begin
        ut.expect(http_util.is_server_error(500)).to_be_true();
        ut.expect(http_util.is_server_error(599)).to_be_true();
    end is_server_error_bounds;

    procedure is_server_error_outside is
    begin
        ut.expect(http_util.is_server_error(499)).to_be_false();
        ut.expect(http_util.is_server_error(600)).to_be_false();
    end is_server_error_outside;

    procedure is_server_error_without_code is
    begin
        ut.expect(http_util.is_server_error(null)).to_be_false();
    end is_server_error_without_code;

    procedure is_retryable_too_many_requests is
    begin
        ut.expect(http_util.is_retryable(429)).to_be_true();
    end is_retryable_too_many_requests;

    procedure is_retryable_server_errors is
    begin
        ut.expect(http_util.is_retryable(500)).to_be_true();
        ut.expect(http_util.is_retryable(503)).to_be_true();
    end is_retryable_server_errors;

    procedure is_retryable_client_errors is
    begin
        ut.expect(http_util.is_retryable(400)).to_be_false();
        ut.expect(http_util.is_retryable(401)).to_be_false();
    end is_retryable_client_errors;

    procedure is_retryable_without_code is
    begin
        ut.expect(http_util.is_retryable(null)).to_be_false();
    end is_retryable_without_code;

    procedure retry_delay_exponential is
    begin
        ut.expect(http_util.retry_delay(1, null)).to_equal(2);

        ut.expect(http_util.retry_delay(2, null)).to_equal(4);

        ut.expect(http_util.retry_delay(4, null)).to_equal(16);

    end retry_delay_exponential;

    procedure retry_delay_retry_after_seconds is
    begin
        ut.expect(http_util.retry_delay(1, '5')).to_equal(5);
    end retry_delay_retry_after_seconds;

    procedure retry_delay_retry_after_capped is
    begin
        ut.expect(http_util.retry_delay(1, '3600')).to_equal(60);
    end retry_delay_retry_after_capped;

    procedure retry_delay_retry_after_date is
    begin
        ut.expect(http_util.retry_delay(1, 'Wed, 21 Oct 2026 07:28:00 GMT')).to_equal(2);
    end retry_delay_retry_after_date;

    procedure set_headers is
    begin
        apex_web_service.g_headers.delete;
        apex_web_service.g_headers(1).name := 'Content-Range';
        apex_web_service.g_headers(1).value := 'offres 0-149/2345';
        apex_web_service.g_headers(2).name := 'Set-Cookie';
        apex_web_service.g_headers(2).value := 'first';
        apex_web_service.g_headers(3).name := 'Set-Cookie';
        apex_web_service.g_headers(3).value := 'last';
    end set_headers;

    procedure response_header_case_insensitive is
    begin
        ut.expect(http_util.response_header('content-range')).to_equal('offres 0-149/2345');
    end response_header_case_insensitive;

    procedure response_header_absent is
    begin
        ut.expect(http_util.response_header('Retry-After')).to_be_null();
    end response_header_absent;

    procedure response_headers_as_json is
    begin
        ut.expect(json_value(http_util.response_headers, '$."Content-Range"')).to_equal('offres 0-149/2345');
    end response_headers_as_json;

    procedure response_headers_repeated is
    begin
        ut.expect(json_value(http_util.response_headers, '$."Set-Cookie"')).to_equal('last');
    end response_headers_repeated;

    procedure response_headers_empty is
    begin
        apex_web_service.g_headers.delete;
        ut.expect(json_serialize(http_util.response_headers)).to_equal('{}');
    end response_headers_empty;

end test_http_util;
/

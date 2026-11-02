create or replace package body jobtracker.test_app_error_handler is

    co_scope              constant logger_logs.scope%type := 'app_error_handler.handle_error';
    co_unexpected_message constant varchar2(100 char) := 'Une erreur inattendue s''est produite. Elle a été journalisée.';
    co_details            constant varchar2(30 char) := 'Détail technique';

    /** Erreur telle qu'APEX la transmet pour une erreur Oracle. */
    function new_error (
        in_ora_sqlcode in pls_integer,
        in_ora_sqlerrm in varchar2
    ) return apex_error.t_error is
        r_error apex_error.t_error;
    begin
        r_error.message := in_ora_sqlerrm;
        r_error.additional_info := co_details;
        r_error.display_location := apex_error.c_on_error_page;
        r_error.ora_sqlcode := in_ora_sqlcode;
        r_error.ora_sqlerrm := in_ora_sqlerrm;
        r_error.is_internal_error := false;
        r_error.is_common_runtime_error := false;
        return r_error;
    end new_error;

    /** Erreur levée par une création d'entreprise refusée par une contrainte. */
    function constraint_error (
        in_siren         in companies.siren%type default null,
        in_linkedin_slug in companies.linkedin_slug%type default null
    ) return apex_error.t_error is
        l_company_id companies.company_id%type;
        e_check_violated exception;
        pragma exception_init ( e_check_violated, -2290 );
    begin
        l_company_id := company_api.create_company('Test',
                                                   in_siren         => in_siren,
                                                   in_linkedin_slug => in_linkedin_slug);

        raise_application_error(app_errors.co_invalid_state, 'Création acceptée');
    exception
        when dup_val_on_index or e_check_violated then
            return new_error(sqlcode, sqlerrm);
    end constraint_error;

    /** Nombre de lignes journalisées par le handler. */
    function logged_error_count return pls_integer is
        l_count pls_integer;
    begin
        select
            count(*)
        into l_count
        from
            logger_logs
        where
            scope = co_scope;

        return l_count;
    end logged_error_count;

    procedure common_runtime_error_unchanged is
        r_error  apex_error.t_error;
        l_logged pls_integer := logged_error_count;
        r_result apex_error.t_error_result;
    begin
        r_error.message := 'Votre session a expiré.';
        r_error.is_internal_error := true;
        r_error.is_common_runtime_error := true;
        r_result := app_error_handler.handle_error(r_error);
        ut.expect(r_result.message).to_equal('Votre session a expiré.');
        ut.expect(logged_error_count).to_equal(l_logged);
    end common_runtime_error_unchanged;

    procedure validation_error_unchanged is
        r_error  apex_error.t_error;
        r_result apex_error.t_error_result;
    begin
        r_error.message := 'Le nom est obligatoire.';
        r_error.display_location := apex_error.c_inline_with_field;
        r_error.is_internal_error := false;
        r_error.is_common_runtime_error := false;
        r_result := app_error_handler.handle_error(r_error);
        ut.expect(r_result.message).to_equal('Le nom est obligatoire.');
        ut.expect(r_result.display_location).to_equal(apex_error.c_inline_with_field);
    end validation_error_unchanged;

    procedure business_error_without_prefix is
        r_result apex_error.t_error_result;
    begin
        r_result := app_error_handler.handle_error(new_error(app_errors.co_row_referenced,
                                                             'ORA-20201: L''entreprise 1 est référencée.'
                                                             || chr(10)
                                                             || 'ORA-06512: at "JOBTRACKER.COMPANY_API", line 155'));

        ut.expect(r_result.message).to_equal('L''entreprise 1 est référencée.');
    end business_error_without_prefix;

    procedure business_error_inline is
        r_result apex_error.t_error_result;
    begin
        r_result := app_error_handler.handle_error(new_error(app_errors.co_circular_reference, 'ORA-20200: Cycle.'));
        ut.expect(r_result.display_location).to_equal(apex_error.c_inline_in_notification);
    end business_error_inline;

    procedure business_error_not_logged is
        l_logged pls_integer := logged_error_count;
        r_result apex_error.t_error_result;
    begin
        r_result := app_error_handler.handle_error(new_error(app_errors.co_circular_reference, 'ORA-20200: Cycle.'));
        ut.expect(logged_error_count).to_equal(l_logged);
    end business_error_not_logged;

    procedure siren_duplicate is
        l_company_id companies.company_id%type;
        r_result     apex_error.t_error_result;
    begin
        l_company_id := company_api.create_company('Original',
                                                   in_siren => '123456789');
        r_result := app_error_handler.handle_error(constraint_error(in_siren => '123456789'));
        ut.expect(r_result.message).to_equal('Ce SIREN est déjà utilisé par une autre entreprise.');
        ut.expect(r_result.display_location).to_equal(apex_error.c_inline_in_notification);
    end siren_duplicate;

    procedure siren_malformed is
        r_result apex_error.t_error_result;
    begin
        r_result := app_error_handler.handle_error(constraint_error(in_siren => '12345678A'));
        ut.expect(r_result.message).to_equal('Le SIREN doit comporter exactement 9 chiffres.');
    end siren_malformed;

    procedure linkedin_slug_malformed is
        r_result apex_error.t_error_result;
    begin
        r_result := app_error_handler.handle_error(constraint_error(in_linkedin_slug => 'company/acme'));
        ut.expect(r_result.message).to_equal('L''identifiant LinkedIn ne doit contenir ni barre oblique ni espace.');
    end linkedin_slug_malformed;

    procedure constraint_without_details is
        r_result apex_error.t_error_result;
    begin
        r_result := app_error_handler.handle_error(constraint_error(in_siren => '12345678A'));
        ut.expect(r_result.additional_info).to_be_null();
    end constraint_without_details;

    procedure unknown_constraint_hidden is
        r_result apex_error.t_error_result;
    begin
        r_result := app_error_handler.handle_error(new_error(-1, 'ORA-00001: unique constraint (JOBTRACKER.COMPANIES_PK) violated'));
        ut.expect(r_result.message).to_equal(co_unexpected_message);
    end unknown_constraint_hidden;

    procedure oracle_error_hidden is
        r_result apex_error.t_error_result;
    begin
        r_result := app_error_handler.handle_error(new_error(-942, 'ORA-00942: table or view does not exist'));
        ut.expect(r_result.message).to_equal(co_unexpected_message);
    end oracle_error_hidden;

    procedure generic_error_hidden is
        r_result apex_error.t_error_result;
    begin
        r_result := app_error_handler.handle_error(new_error(app_errors.co_not_found, 'ORA-20001: Unknown company: 1'));
        ut.expect(r_result.message).to_equal(co_unexpected_message);
    end generic_error_hidden;

    procedure integration_error_hidden is
        r_result apex_error.t_error_result;
    begin
        r_result := app_error_handler.handle_error(new_error(app_errors.co_http_error, 'ORA-20100: HTTP 500'));
        ut.expect(r_result.message).to_equal(co_unexpected_message);
    end integration_error_hidden;

    procedure internal_error_hidden is
        r_error  apex_error.t_error;
        r_result apex_error.t_error_result;
    begin
        r_error.message := 'Region query failed';
        r_error.is_internal_error := true;
        r_error.is_common_runtime_error := false;
        r_result := app_error_handler.handle_error(r_error);
        ut.expect(r_result.message).to_equal(co_unexpected_message);
    end internal_error_hidden;

    procedure unexpected_without_details is
        r_result apex_error.t_error_result;
    begin
        r_result := app_error_handler.handle_error(new_error(-942, 'ORA-00942: table or view does not exist'));
        ut.expect(r_result.additional_info).to_be_null();
    end unexpected_without_details;

    procedure unexpected_error_logged is
        l_logged pls_integer := logged_error_count;
        r_result apex_error.t_error_result;
    begin
        r_result := app_error_handler.handle_error(new_error(-942, 'ORA-00942: table or view does not exist'));
        ut.expect(logged_error_count).to_equal(l_logged + 1);
    end unexpected_error_logged;

end test_app_error_handler;
/

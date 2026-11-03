create or replace package body jobtracker.app_error_handler is

    co_scope              constant logger_logs.scope%type := lower($$plsql_unit)
                                                || '.handle_error';
    co_unexpected_message constant varchar2(100 char) := 'Une erreur inattendue s''est produite. Elle a été journalisée.';

    -- Plage des erreurs métier, affichables : voir l'en-tête de app_errors
    co_business_error_min constant pls_integer := -20299;
    co_business_error_max constant pls_integer := -20200;

    -- Violations de contraintes traduites : ORA-00001 et ORA-02290
    co_unique_violated    constant pls_integer := -1;
    co_check_violated     constant pls_integer := -2290;

    -- Modification concurrente détectée par le formulaire (Prevent Lost Updates) :
    -- APEX la lève en ORA-20987, code partagé avec ses erreurs internes
    co_data_has_changed   constant varchar2(30 char) := 'APEX.DATA_HAS_CHANGED';

    /**
     * Message d'une contrainte.
     * @param in_constraint_name nom de la contrainte, sans le schéma
     * @return message pour l'utilisateur, null si la contrainte n'est pas traduite
     */
    function constraint_message (
        in_constraint_name in varchar2
    ) return varchar2 is
    begin
        return
            case in_constraint_name
                when 'COMPANIES_SIREN_UK'         then
                    'Ce SIREN est déjà utilisé par une autre entreprise.'
                when 'COMPANIES_SIREN_CK'         then
                    'Le SIREN doit comporter exactement 9 chiffres.'
                when 'COMPANIES_LINKEDIN_SLUG_CK' then
                    'L''identifiant LinkedIn ne doit contenir ni barre oblique ni espace.'
            end;
    end constraint_message;

    /**
     * Message d'une erreur Oracle prévue.
     * @param p_error erreur transmise par APEX
     * @return message pour l'utilisateur, null si l'erreur n'est pas prévue
     */
    function expected_message (
        p_error in apex_error.t_error
    ) return varchar2 is
    begin
        if p_error.apex_error_code = co_data_has_changed then
            return 'Ces données ont été modifiées entre-temps. Rechargez la page avant d''enregistrer.';
        elsif p_error.ora_sqlcode between co_business_error_min and co_business_error_max then
            return apex_error.get_first_ora_error_text(p_error => p_error);
        elsif p_error.ora_sqlcode in ( co_unique_violated, co_check_violated ) then
            return constraint_message(apex_error.extract_constraint_name(p_error => p_error));
        end if;

        return null;
    end expected_message;

    function handle_error (
        p_error in apex_error.t_error
    ) return apex_error.t_error_result is
        l_result  apex_error.t_error_result;
        l_message varchar2(32767 byte);
    begin
        l_result := apex_error.init_error_result(p_error => p_error);

        -- Session expirée, droits, validation de page, apex_error.add_error :
        -- messages déjà écrits pour l'utilisateur
        if p_error.is_common_runtime_error
        or (
            p_error.ora_sqlcode is null
            and not p_error.is_internal_error
        ) then
            return l_result;
        end if;

        l_message := expected_message(p_error);
        l_result.additional_info := null;
        if l_message is not null then
            l_result.message := l_message;
            l_result.display_location := apex_error.c_inline_in_notification;
        else
            logger.log_error(p_error.message,
                             co_scope,
                             'apex_error_code: '
                             || p_error.apex_error_code
                             || chr(10)
                             || p_error.ora_sqlerrm
                             || chr(10)
                             || p_error.error_backtrace
                             || chr(10)
                             || p_error.error_statement);

            l_result.message := co_unexpected_message;
        end if;

        return l_result;
    end handle_error;

end app_error_handler;
/


-- sqlcl_snapshot {"hash":"b3d5e12918ae06c9de585fe5aba474ca9f16186a","type":"PACKAGE_BODY","name":"APP_ERROR_HANDLER","schemaName":"JOBTRACKER","sxml":""}
create or replace package body jobtracker.app_message is

    co_scope         constant logger_logs.scope%type := lower($$plsql_unit);

    -- Paramètre du texte : {1} à {3}
    co_param_pattern constant varchar2(10 char) := '\{[1-3]\}';
    co_param_length  constant pls_integer := 3;

    /**
     * Remplace les paramètres en un seul parcours du texte : une valeur qui
     * contient elle-même {1} à {3} (nom saisi par l'utilisateur) n'est pas
     * substituée à son tour, contrairement à des REPLACE successifs.
     */
    function substitute (
        in_text   in varchar2,
        in_param1 in varchar2,
        in_param2 in varchar2,
        in_param3 in varchar2
    ) return varchar2 is
        l_result   varchar2(32767 byte);
        l_position pls_integer := 1;
        l_match    pls_integer;
    begin
        loop
            l_match := regexp_instr(in_text, co_param_pattern, l_position);
            exit when l_match = 0;
            l_result := l_result
                        || substr(in_text, l_position, l_match - l_position)
                        ||
                case substr(in_text, l_match + 1, 1)
                    when '1' then
                        in_param1
                    when '2' then
                        in_param2
                    else
                        in_param3
                end;

            l_position := l_match + co_param_length;
        end loop;

        return l_result || substr(in_text, l_position);
    end substitute;

    function current_language return varchar2 is
    begin
        if sys_context('APEX$SESSION', 'APP_SESSION') is null then
            return co_default_language;
        end if;
        return coalesce(
            lower(substr(apex_util.get_session_lang, 1, 2)),
            co_default_language
        );

    end current_language;

    function get_text (
        in_message_key in app_messages.message_key%type,
        in_param1      in varchar2 default null,
        in_param2      in varchar2 default null,
        in_param3      in varchar2 default null,
        in_language    in app_messages.language_code%type default current_language
    ) return varchar2 is
        l_text app_messages.message_text%type;
    begin
        -- Langue demandée en priorité, sinon langue de repli
        select
            message_text
        into l_text
        from
            app_messages
        where
                message_key = in_message_key
            and language_code in ( in_language, co_default_language )
        order by
            case language_code
                when in_language then
                    0
                else
                    1
            end
        fetch first 1 row only;

        return substitute(l_text, in_param1, in_param2, in_param3);
    exception
        when no_data_found then
            logger.log_warning('Message absent du catalogue : ' || in_message_key, co_scope);
            return in_message_key;
    end get_text;

    procedure raise_error (
        in_error_code  in pls_integer,
        in_message_key in app_messages.message_key%type,
        in_param1      in varchar2 default null,
        in_param2      in varchar2 default null,
        in_param3      in varchar2 default null
    ) is
    begin
        raise_application_error(in_error_code,
                                get_text(in_message_key, in_param1, in_param2, in_param3));
    end raise_error;

end app_message;
/


-- sqlcl_snapshot {"hash":"959adf50c7c3e75523663b5d0dfa1989ff5617b4","type":"PACKAGE_BODY","name":"APP_MESSAGE","schemaName":"JOBTRACKER","sxml":""}
create or replace package jobtracker.app_message authid definer is
    /**
     * Messages de la base affichés à l'utilisateur, lus dans le catalogue
     * app_messages dans la langue de la session, avec repli sur le français.
     * Les messages techniques, jamais affichés (journal, erreurs imprévues),
     * restent en dur dans le code et n'entrent pas dans le catalogue.
     */

    -- Langue de repli, celle de tous les messages du catalogue
    co_default_language constant varchar2(2 char) := 'fr';

    /**
     * Langue de la session : celle de la session APEX, réduite à son code
     * ISO 639-1 ('en-us' donne 'en'), sinon la langue de repli (tests, jobs).
     * Seul point de couplage du catalogue avec APEX.
     */
    function current_language return varchar2;

    /**
     * Présence d'un message dans le catalogue, dans la langue de repli :
     * permet à l'appelant de traiter l'absence autrement que par la clé
     * renvoyée par get_text (contrainte non traduite, par exemple).
     */
    function has_message (
        in_message_key in app_messages.message_key%type
    ) return boolean;

    /**
     * Texte d'un message, paramètres substitués.
     * Repli sur la langue par défaut si le message n'existe pas dans la
     * langue demandée.
     * @param in_param1 remplace {1} dans le texte ; null : chaîne vide
     * @return la clé elle-même si le message est absent du catalogue
     *         (l'absence est journalisée)
     */
    function get_text (
        in_message_key in app_messages.message_key%type,
        in_param1      in varchar2 default null,
        in_param2      in varchar2 default null,
        in_param3      in varchar2 default null,
        in_language    in app_messages.language_code%type default current_language
    ) return varchar2;

    /**
     * Lève une erreur applicative avec le texte d'un message du catalogue,
     * dans la langue de la session.
     * @param in_error_code code de app_errors (co_...)
     * @throws in_error_code toujours
     */
    procedure raise_error (
        in_error_code  in pls_integer,
        in_message_key in app_messages.message_key%type,
        in_param1      in varchar2 default null,
        in_param2      in varchar2 default null,
        in_param3      in varchar2 default null
    );

end app_message;
/


-- sqlcl_snapshot {"hash":"a3157d330653063a60db7ea8ac2c0cde78c42a32","type":"PACKAGE_SPEC","name":"APP_MESSAGE","schemaName":"JOBTRACKER","sxml":""}
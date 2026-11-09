create or replace package body jobtracker.test_app_message is

    /** Ajoute un message de test au catalogue. */
    procedure add_message (
        in_message_key   in app_messages.message_key%type,
        in_language_code in app_messages.language_code%type,
        in_message_text  in app_messages.message_text%type
    ) is
    begin
        insert into app_messages (
            message_key,
            language_code,
            message_text
        ) values
            ( in_message_key,
              in_language_code,
              in_message_text );

    end add_message;

    procedure default_language_outside_apex is
    begin
        ut.expect(app_message.current_language).to_equal('fr');
    end default_language_outside_apex;

    procedure has_message_in_default_language is
    begin
        add_message('TEST_GREETING', 'fr', 'Bonjour');
        ut.expect(app_message.has_message('TEST_GREETING')).to_be_true();
    end has_message_in_default_language;

    procedure has_message_other_language_only is
    begin
        add_message('TEST_GREETING', 'en', 'Hello');
        ut.expect(app_message.has_message('TEST_GREETING')).to_be_false();
    end has_message_other_language_only;

    procedure text_in_requested_language is
    begin
        add_message('TEST_GREETING', 'fr', 'Bonjour');
        add_message('TEST_GREETING', 'en', 'Hello');
        ut.expect(app_message.get_text('TEST_GREETING',
                                       in_language => 'en')).to_equal('Hello');

    end text_in_requested_language;

    procedure fallback_to_default_language is
    begin
        add_message('TEST_GREETING', 'fr', 'Bonjour');
        ut.expect(app_message.get_text('TEST_GREETING',
                                       in_language => 'en')).to_equal('Bonjour');

    end fallback_to_default_language;

    procedure unknown_key_returned is
    begin
        ut.expect(app_message.get_text('TEST_UNKNOWN')).to_equal('TEST_UNKNOWN');
    end unknown_key_returned;

    procedure params_in_text_order is
    begin
        add_message('TEST_PARAMS', 'fr', '{2} avant {1}, {2} encore');
        ut.expect(app_message.get_text('TEST_PARAMS', 'A', 'B')).to_equal('B avant A, B encore');

    end params_in_text_order;

    procedure param_value_not_substituted is
    begin
        add_message('TEST_PARAMS', 'fr', '{1} et {2}');
        ut.expect(app_message.get_text('TEST_PARAMS', 'nom {2}', 'B')).to_equal('nom {2} et B');

    end param_value_not_substituted;

    procedure missing_param_empty is
    begin
        add_message('TEST_PARAMS', 'fr', '[{1}]');
        ut.expect(app_message.get_text('TEST_PARAMS')).to_equal('[]');
    end missing_param_empty;

    procedure raise_error_with_text is
    begin
        add_message('TEST_ERROR', 'fr', 'Erreur sur {1}');
        app_message.raise_error(app_errors.co_circular_reference, 'TEST_ERROR', 'X');
        ut.fail('Aucune erreur levée');
    exception
        when app_errors.e_circular_reference then
            ut.expect(sqlerrm).to_equal('ORA-20200: Erreur sur X');
    end raise_error_with_text;

    procedure catalog_complete is
        l_missing_count pls_integer;
    begin
        -- Couples clé et langue attendus, absents du catalogue
        select
            count(*)
        into l_missing_count
        from
                 (
                select distinct
                    message_key
                from
                    app_messages
            ) k
            cross join (
                select distinct
                    language_code
                from
                    app_messages
            ) l
        where
            not exists (
                select
                    null
                from
                    app_messages m
                where
                        m.message_key = k.message_key
                    and m.language_code = l.language_code
            );

        ut.expect(l_missing_count).to_equal(0);
    end catalog_complete;

    procedure catalog_has_default_language is
        l_missing_count pls_integer;
    begin
        select
            count(distinct message_key)
        into l_missing_count
        from
            app_messages k
        where
            not exists (
                select
                    null
                from
                    app_messages m
                where
                        m.message_key = k.message_key
                    and m.language_code = app_message.co_default_language
            );

        ut.expect(l_missing_count).to_equal(0);
    end catalog_has_default_language;

end test_app_message;
/

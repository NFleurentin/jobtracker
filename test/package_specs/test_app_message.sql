create or replace package jobtracker.test_app_message authid definer is
    -- =========================================================================
    -- Tests de app_message, hors session APEX : la langue courante est donc
    -- la langue de repli. Les messages de test (clés TEST_) sont insérés par
    -- chaque test ; utPLSQL annule ces écritures à la fin (rollback auto).
    -- =========================================================================

    --%suite(app_message)

    --%context(langue)

    --%test(renvoie le français hors session APEX)
    procedure default_language_outside_apex;

    --%endcontext

    --%context(présence)

    --%test(trouve un message de la langue de repli)
    procedure has_message_in_default_language;

    --%test(ignore un message absent de la langue de repli)
    procedure has_message_other_language_only;

    --%endcontext

    --%context(texte)

    --%test(renvoie le texte dans la langue demandée)
    procedure text_in_requested_language;

    --%test(se replie sur le français si la langue manque)
    procedure fallback_to_default_language;

    --%test(renvoie la clé d'un message absent)
    procedure unknown_key_returned;

    --%test(substitue les paramètres dans l'ordre du texte)
    procedure params_in_text_order;

    --%test(ne substitue pas un paramètre contenu dans une valeur)
    procedure param_value_not_substituted;

    --%test(remplace un paramètre absent par une chaîne vide)
    procedure missing_param_empty;

    --%endcontext

    --%context(erreur)

    --%test(lève le code demandé avec le texte du message)
    procedure raise_error_with_text;

    --%endcontext

    --%context(catalogue)

    --%test(chaque message existe dans toutes les langues du catalogue)
    procedure catalog_complete;

    --%test(chaque message existe dans la langue de repli)
    procedure catalog_has_default_language;

    --%endcontext
end test_app_message;
/

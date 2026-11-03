create or replace package jobtracker.test_app_error_handler authid definer is
    -- =========================================================================
    -- Tests de app_error_handler, avec des erreurs construites comme celles
    -- d'APEX (aucune session requise). Les contraintes sont réellement violées ;
    -- utPLSQL annule ces écritures à la fin (rollback auto). La journalisation,
    -- en transaction autonome, laisse ses lignes dans logger_logs.
    -- =========================================================================

    --%suite(app_error_handler)

    --%context(erreurs prévues par APEX)

    --%test(laisse passer une erreur courante d'APEX sans la journaliser)
    procedure common_runtime_error_unchanged;

    --%test(laisse passer le message d'une validation de page)
    procedure validation_error_unchanged;

    --%test(traduit une modification concurrente sans la journaliser)
    procedure data_has_changed_translated;

    --%test(masque une autre erreur ORA-20987 d'APEX)
    procedure other_apex_error_hidden;

    --%endcontext

    --%context(erreurs métier)

    --%test(retire le préfixe Oracle et la pile d'appels)
    procedure business_error_without_prefix;

    --%test(affiche le message dans la notification de la page)
    procedure business_error_inline;

    --%test(ne journalise pas une erreur métier)
    procedure business_error_not_logged;

    --%endcontext

    --%context(contraintes)

    --%test(traduit un SIREN en double)
    procedure siren_duplicate;

    --%test(traduit un SIREN mal formé)
    procedure siren_malformed;

    --%test(traduit un identifiant LinkedIn mal formé)
    procedure linkedin_slug_malformed;

    --%test(ne laisse pas de détail technique dans additional_info)
    procedure constraint_without_details;

    --%test(masque une contrainte non traduite)
    procedure unknown_constraint_hidden;

    --%endcontext

    --%context(erreurs imprévues)

    --%test(masque une erreur Oracle)
    procedure oracle_error_hidden;

    --%test(masque une erreur générique de app_errors)
    procedure generic_error_hidden;

    --%test(masque une erreur d'intégration de app_errors)
    procedure integration_error_hidden;

    --%test(masque une erreur interne d'APEX sans code Oracle)
    procedure internal_error_hidden;

    --%test(retire le détail technique de additional_info)
    procedure unexpected_without_details;

    --%test(journalise l'erreur)
    procedure unexpected_error_logged;

    --%endcontext
end test_app_error_handler;
/

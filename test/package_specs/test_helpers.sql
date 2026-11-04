create or replace package jobtracker.test_helpers authid definer is
    -- =========================================================================
    -- Procédures communes aux suites de test, appelées par leurs annotations
    -- (--%beforetest(test_helpers.<procédure>)). Pas une suite : aucune
    -- annotation --%suite.
    -- =========================================================================

    /**
    * Ouvre une session APEX en anglais, en transaction autonome :
    * create_session fait un commit quand une session APEX a déjà été
    * détachée dans la même session de base (constaté en enchaînant les
    * suites), ce qui empêcherait le rollback automatique d'utPLSQL.
    */
    procedure start_english_session;

    /**
    * Détache la session APEX ouverte par un test, en transaction autonome :
    * detach et delete_session font un commit, qui empêcherait le rollback
    * automatique d'utPLSQL.
    */
    procedure end_english_session;

end test_helpers;
/

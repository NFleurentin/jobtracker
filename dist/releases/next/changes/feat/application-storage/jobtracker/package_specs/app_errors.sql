-- liquibase formatted sql
-- changeset JOBTRACKER:1794246056141 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/package_specs/app_errors.sql
-- sqlcl_snapshot src/database/jobtracker/package_specs/app_errors.sql:2dfef3d80768248c63575fa575721a948529aa46:91d3a55d6038f9592fb51d6a2d5345b44463c230:alter

create or replace package jobtracker.app_errors authid definer is
    /**
     * Erreurs applicatives, communes à tous les packages : une erreur par
     * nature, le contexte précis étant porté par le message.
     * Pour chaque erreur, un code (co_, pour RAISE_APPLICATION_ERROR et les
     * tests --%throws) et une exception nommée (e_, pour l'interception).
     *
     * Plages par thème, numérotation continue dans chaque plage, ajout en fin
     * de sa section, numéro jamais réutilisé :
     *   -20001 à -20099 : génériques (données, états)
     *   -20100 à -20199 : intégration (API externes)
     *   -20200 à -20299 : métier (règles de gestion, affichables à l'utilisateur)
     *   -20300 à -20999 : réservé
     * pragma exception_init exige un littéral : le numéro est écrit deux fois.
     */

    -- -------------------------------------------------------------------------
    -- Génériques : -20001 à -20099
    -- -------------------------------------------------------------------------

    -- Référence inexistante (source, run, requête...)
    co_not_found constant pls_integer := -20001;
    e_not_found exception;
    pragma exception_init ( e_not_found, -20001 );

    -- Objet dans un état qui interdit l'opération (run déjà clos...)
    co_invalid_state constant pls_integer := -20002;
    e_invalid_state exception;
    pragma exception_init ( e_invalid_state, -20002 );

    -- -------------------------------------------------------------------------
    -- Intégration : -20100 à -20199
    -- -------------------------------------------------------------------------

    -- Appel HTTP en échec : code d'erreur, ou nouveaux essais épuisés
    co_http_error constant pls_integer := -20100;
    e_http_error exception;
    pragma exception_init ( e_http_error, -20100 );

    -- Réponse d'une API inexploitable (en-tête absent ou illisible...)
    co_invalid_response constant pls_integer := -20101;
    e_invalid_response exception;
    pragma exception_init ( e_invalid_response, -20101 );

    -- Limite d'une API dépassée (plafond de résultats...)
    co_limit_exceeded constant pls_integer := -20102;
    e_limit_exceeded exception;
    pragma exception_init ( e_limit_exceeded, -20102 );

    -- -------------------------------------------------------------------------
    -- Métier : -20200 à -20299
    -- -------------------------------------------------------------------------

    -- Rattachement qui créerait un cycle dans une hiérarchie (entreprises...)
    co_circular_reference constant pls_integer := -20200;
    e_circular_reference exception;
    pragma exception_init ( e_circular_reference, -20200 );

    -- Suppression d'une ligne encore référencée par d'autres données
    co_row_referenced constant pls_integer := -20201;
    e_row_referenced exception;
    pragma exception_init ( e_row_referenced, -20201 );

    -- Valeur déjà présente là où elle doit être unique (libellé de référentiel...)
    co_duplicate_value constant pls_integer := -20202;
    e_duplicate_value exception;
    pragma exception_init ( e_duplicate_value, -20202 );

    -- Ligne protégée par l'application, non supprimable (entreprise générique,
    -- seul statut d'une candidature...)
    co_protected_row constant pls_integer := -20203;
    e_protected_row exception;
    pragma exception_init ( e_protected_row, -20203 );

    -- Ligne verrouillée par un autre traitement au-delà du délai d'attente
    co_row_locked constant pls_integer := -20204;
    e_row_locked exception;
    pragma exception_init ( e_row_locked, -20204 );
end app_errors;
/


-- liquibase formatted sql
-- changeset JOBTRACKER:1793212579399 stripComments:false  logicalFilePath:feat/collect-france-travail-api/jobtracker/package_specs/app_errors.sql
-- sqlcl_snapshot src/database/jobtracker/package_specs/app_errors.sql:null:513facdaec90d3121e59a5a6cc8f1eb0600af2ad:create

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
end app_errors;
/


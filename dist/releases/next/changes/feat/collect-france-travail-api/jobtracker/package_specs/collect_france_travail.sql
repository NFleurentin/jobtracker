-- liquibase formatted sql
-- changeset JOBTRACKER:1793212579406 stripComments:false  logicalFilePath:feat/collect-france-travail-api/jobtracker/package_specs/collect_france_travail.sql
-- sqlcl_snapshot src/database/jobtracker/package_specs/collect_france_travail.sql:null:7ae70f1af223d715a2ccf08b82e63416a5ab3788:create

create or replace package jobtracker.collect_france_travail authid definer is
    /**
     * Collecte des offres de l'API Offres d'emploi v2 de France Travail,
     * écrite brute en staging (collect_staging).
     * Un run par recherche ; la première erreur arrête toute la collecte.
     */

    -- Pagination par le paramètre range : pages de 150, index de début <= 3000,
    -- donc 3150 résultats au plus par recherche
    co_page_size constant pls_integer := 150;
    co_max_offset constant pls_integer := 3000;
    co_max_results constant pls_integer := 3150;

    -- Nouveaux essais sur 429 et 5xx
    co_max_attempts constant pls_integer := 5;

    /**
     * Point d'entrée de la collecte (DBMS_SCHEDULER, ou appel manuel en dev).
     * Seul à faire COMMIT, y compris en cas d'échec pour garder la trace,
     * avant de relancer l'erreur.
     * @throws app_errors.co_invalid_response, app_errors.co_limit_exceeded,
     *         app_errors.co_http_error, et toute erreur de collect_staging
     */
    procedure run;

    -- -------------------------------------------------------------------------
    -- Fonctions pures, exposées pour les tests utPLSQL
    -- -------------------------------------------------------------------------

    /**
     * Total de résultats d'une recherche.
     * @param in_content_range en-tête Content-Range ("offres 0-149/2345")
     * @return total, null si l'en-tête est absent ou illisible
     */
    function parse_total (
        in_content_range in varchar2
    ) return pls_integer;

    /**
     * Indique s'il reste une page à demander. L'API peut répondre 206 sur la
     * page qui contient le dernier résultat : le total évite une page vide.
     * @param in_offset index de début de la page reçue
     * @param in_total  total de la recherche, null si inconnu
     */
    function has_more (
        in_status_code in pls_integer,
        in_offset      in pls_integer,
        in_total       in pls_integer
    ) return boolean;

    /**
     * Contrôle d'une page 206 : sans total lisible, ou au-delà du plafond de
     * l'API, la recherche serait tronquée.
     * @throws app_errors.co_invalid_response total illisible
     * @throws app_errors.co_limit_exceeded  total supérieur à co_max_results
     */
    procedure check_page (
        in_status_code in pls_integer,
        in_total       in pls_integer
    );

end collect_france_travail;
/


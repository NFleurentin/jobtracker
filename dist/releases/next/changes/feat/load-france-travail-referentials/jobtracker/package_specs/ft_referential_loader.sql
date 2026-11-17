-- liquibase formatted sql
-- changeset JOBTRACKER:1794932808366 stripComments:false  logicalFilePath:feat/load-france-travail-referentials/jobtracker/package_specs/ft_referential_loader.sql
-- sqlcl_snapshot src/database/jobtracker/package_specs/ft_referential_loader.sql:null:322f10b57d746df92becd8f376e9aad830dbcbc6:create

create or replace package jobtracker.ft_referential_loader authid definer is
    /**
     * Chargement des référentiels de France Travail (tables ft_) depuis l'API.
     * Un chargement (ft_referential_loads) enchaîne les référentiels, chacun
     * validé à part : un échec n'empêche pas les suivants. Chaque code reçu
     * prend l'identifiant du chargement ; la disparition d'un code s'en déduit
     * (vues ft_<entité>_details), sans marquage ni suppression.
     * Lancé à la demande, par un job ponctuel (start_load), jamais périodique.
     */

    -- Référentiels, dans l'ordre de chargement imposé par les clés étrangères
    co_referential_regions constant varchar2(30 char) := 'REGIONS';
    co_referential_departments constant varchar2(30 char) := 'DEPARTMENTS';
    co_referential_communes constant varchar2(30 char) := 'COMMUNES';
    co_referential_countries constant varchar2(30 char) := 'COUNTRIES';
    co_referential_continents constant varchar2(30 char) := 'CONTINENTS';
    co_referential_contract_types constant varchar2(30 char) := 'CONTRACT_TYPES';

    -- Job ponctuel du chargement, présent tant qu'il tourne (auto_drop)
    co_job_name constant varchar2(128 char) := 'FT_REFERENTIAL_LOAD';

    /**
     * Lance un chargement en arrière-plan, par un job ponctuel qui appelle
     * run_load et disparaît à la fin. Appelé par l'application APEX.
     * DBMS_SCHEDULER.CREATE_JOB valide la transaction en cours (DDL) :
     * l'appelant ne doit rien avoir écrit avant.
     * @param in_referential un référentiel (co_referential_) ; null pour tous
     * @throws app_errors.co_already_running un chargement tourne déjà
     * @throws app_errors.co_not_found référentiel inconnu
     */
    procedure start_load (
        in_referential in varchar2 default null
    );

    /**
     * Point d'entrée du job : charge les référentiels un par un, chacun
     * validé (COMMIT) ou annulé à part, puis clôt le chargement avec son
     * statut (SUCCESS, PARTIAL, ERROR) et le détail par référentiel.
     * Se lance aussi directement en SQLcl, après la reconstruction d'une base.
     * @param in_referential un référentiel (co_referential_) ; null pour tous
     * @throws app_errors.co_not_found référentiel inconnu
     */
    procedure run_load (
        in_referential in varchar2 default null
    );

    /**
     * Charge dans la table d'un référentiel la réponse de son endpoint :
     * MERGE sur le code, libellé et rattachement mis à jour, identifiant du
     * chargement posé sur chaque code reçu. Un rattachement à un code absent
     * de la table parente est chargé nul et signalé en anomalie.
     * Aucun COMMIT. Séparé de l'appel pour être testé sur des fixtures.
     * @param in_referential référentiel (co_referential_)
     * @param in_load_id     chargement en cours (ft_referential_loads)
     * @param in_response    corps de la réponse : tableau JSON d'objets
     * @return détail : received (codes reçus), no_longer_current (codes du
     *         chargement précédent absents de celui-ci), anomalies (tableau de
     *         { parent_code, row_count }, communes et départements seulement)
     * @throws app_errors.co_invalid_response réponse vide, JSON invalide ou
     *         autre chose qu'un tableau ; aucun MERGE
     * @throws app_errors.co_not_found référentiel inconnu
     */
    function load_response (
        in_referential in varchar2,
        in_load_id     in ft_referential_loads.ft_referential_load_id%type,
        in_response    in clob
    ) return json_object_t;

end ft_referential_loader;
/


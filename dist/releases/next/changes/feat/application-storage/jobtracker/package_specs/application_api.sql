-- liquibase formatted sql
-- changeset JOBTRACKER:1794246055956 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/package_specs/application_api.sql
-- sqlcl_snapshot src/database/jobtracker/package_specs/application_api.sql:null:723f76a57aff24692893c7376d06e658d63e62fa:create

create or replace package jobtracker.application_api authid definer is
    /**
     * Écritures sur les candidatures et l'historique de leurs statuts : point
     * d'entrée unique, appelé par APEX. Aucun COMMIT : la transaction
     * appartient à l'appelant.
     *
     * Le statut courant n'est pas stocké : application_details le calcule
     * depuis l'historique (changement le plus récent).
     *
     * L'historique antérieur ne se réécrit pas : ajout, note modifiable,
     * correction ou annulation du seul changement le plus récent.
     *
     * Une seule candidature ouverte (statut courant non final) par
     * entreprise, l'entreprise générique exceptée. Le contrôle suit chaque
     * écriture qui peut ouvrir une candidature, sous verrou de l'entreprise :
     * deux sessions ne peuvent pas ouvrir chacune une candidature pour la même
     * entreprise. Verrous toujours pris dans le même ordre (candidature, puis
     * entreprises par identifiant croissant) : pas d'interblocage. Attente
     * bornée à 5 secondes : au-delà, app_errors.co_row_locked (verrou gardé
     * par un job ou un script).
     *
     * Chaque procédure est atomique : un refus annule ses propres écritures.
     */

    /**
     * Crée une candidature et son statut initial.
     * @param in_changed_at date du statut initial, saisie a posteriori possible
     * @return identifiant de la candidature
     * @throws app_errors.co_not_found entreprise inexistante
     * @throws app_errors.co_duplicate_value candidature déjà ouverte pour
     *         l'entreprise, statut initial non final
     */
    function create_application (
        in_company_id                   in applications.company_id%type,
        in_application_type_id          in applications.application_type_id%type,
        in_job_title                    in applications.job_title%type,
        in_application_status_id        in application_status_changes.application_status_id%type,
        in_changed_at                   in application_status_changes.changed_at%type default systimestamp,
        in_annual_salary_proposed_euros in applications.annual_salary_proposed_euros%type default null,
        in_daily_rate_proposed_euros    in applications.daily_rate_proposed_euros%type default null,
        in_interest_rating              in applications.interest_rating%type default null,
        in_note_text                    in applications.note_text%type default null
    ) return applications.application_id%type;

    /**
     * Remplace les données d'une candidature, hors historique, et met à jour
     * updated_at. Aucun paramètre n'a de valeur par défaut : null efface la
     * colonne.
     * @throws app_errors.co_not_found candidature ou entreprise inexistante
     * @throws app_errors.co_duplicate_value candidature ouverte déplacée vers
     *         une entreprise qui en a déjà une
     */
    procedure update_application (
        in_application_id               in applications.application_id%type,
        in_company_id                   in applications.company_id%type,
        in_application_type_id          in applications.application_type_id%type,
        in_job_title                    in applications.job_title%type,
        in_annual_salary_proposed_euros in applications.annual_salary_proposed_euros%type,
        in_daily_rate_proposed_euros    in applications.daily_rate_proposed_euros%type,
        in_interest_rating              in applications.interest_rating%type,
        in_note_text                    in applications.note_text%type
    );

    /**
     * Supprime une candidature et son historique.
     * @throws app_errors.co_not_found candidature inexistante
     */
    procedure delete_application (
        in_application_id in applications.application_id%type
    );

    /**
     * Ajoute un changement de statut et met à jour updated_at de la
     * candidature.
     * @param in_changed_at date du changement, antérieure au statut courant
     *        pour une saisie a posteriori
     * @return identifiant du changement
     * @throws app_errors.co_not_found candidature inexistante
     * @throws app_errors.co_duplicate_value candidature rouverte alors qu'une
     *         autre est ouverte pour l'entreprise
     */
    function add_status_change (
        in_application_id        in application_status_changes.application_id%type,
        in_application_status_id in application_status_changes.application_status_id%type,
        in_changed_at            in application_status_changes.changed_at%type default systimestamp,
        in_note_text             in application_status_changes.note_text%type default null
    ) return application_status_changes.application_status_change_id%type;

    /**
     * Corrige le changement de statut le plus récent d'une candidature (statut,
     * date, note) et met à jour updated_at. Seul moyen de corriger le statut
     * initial, qui ne se supprime pas. Aucun paramètre n'a de valeur par
     * défaut.
     * @throws app_errors.co_not_found changement inexistant
     * @throws app_errors.co_protected_row changement qui n'est pas le plus
     *         récent, ou date antérieure au changement précédent
     * @throws app_errors.co_duplicate_value candidature rouverte alors qu'une
     *         autre est ouverte pour l'entreprise
     */
    procedure correct_latest_status_change (
        in_application_status_change_id in application_status_changes.application_status_change_id%type,
        in_application_status_id        in application_status_changes.application_status_id%type,
        in_changed_at                   in application_status_changes.changed_at%type,
        in_note_text                    in application_status_changes.note_text%type
    );

    /**
     * Remplace la note d'un changement de statut, même antérieur, et met à
     * jour updated_at de la candidature. Ni statut ni date : seul le
     * changement le plus récent se corrige (correct_latest_status_change).
     * @param in_note_text null efface la note
     * @throws app_errors.co_not_found changement inexistant
     */
    procedure update_status_note (
        in_application_status_change_id in application_status_changes.application_status_change_id%type,
        in_note_text                    in application_status_changes.note_text%type
    );

    /**
     * Annule le changement de statut le plus récent d'une candidature et met
     * à jour updated_at. L'historique antérieur n'est jamais modifié.
     * @throws app_errors.co_not_found changement inexistant
     * @throws app_errors.co_protected_row changement qui n'est pas le plus
     *         récent, ou seul changement restant : il ne se supprime qu'avec
     *         la candidature, ou se corrige
     * @throws app_errors.co_duplicate_value candidature rouverte alors qu'une
     *         autre est ouverte pour l'entreprise
     */
    procedure delete_status_change (
        in_application_status_change_id in application_status_changes.application_status_change_id%type
    );

end application_api;
/


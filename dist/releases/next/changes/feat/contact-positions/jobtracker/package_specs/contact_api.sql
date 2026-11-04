-- liquibase formatted sql
-- changeset JOBTRACKER:1793796994215 stripComments:false  logicalFilePath:feat/contact-positions/jobtracker/package_specs/contact_api.sql
-- sqlcl_snapshot src/database/jobtracker/package_specs/contact_api.sql:214aa39fa9c29c86a5117af33557e6b68cd20ace:4707f25a53494913950a49cf4abfd471839f68b4:alter

create or replace package jobtracker.contact_api authid definer is
    /**
     * Écritures sur les contacts et leurs postes dans les entreprises : point
     * d'entrée unique, appelé par APEX.
     * Aucun COMMIT : la transaction appartient à l'appelant.
     * Les contraintes de la table restent la dernière ligne de défense : un
     * identifiant LinkedIn mal formé remonte en erreur Oracle.
     */

    /**
     * Crée un contact.
     * @return identifiant du contact
     */
    function create_contact (
        in_last_name     in contacts.last_name%type,
        in_first_name    in contacts.first_name%type default null,
        in_salutation_id in contacts.salutation_id%type default null,
        in_email         in contacts.email%type default null,
        in_phone         in contacts.phone%type default null,
        in_linkedin_slug in contacts.linkedin_slug%type default null,
        in_note_text     in contacts.note_text%type default null
    ) return contacts.contact_id%type;

    /**
     * Remplace toutes les données d'un contact et met à jour updated_at.
     * Aucun paramètre n'a de valeur par défaut : null efface la colonne.
     * @throws app_errors.co_not_found contact inexistant
     */
    procedure update_contact (
        in_contact_id    in contacts.contact_id%type,
        in_last_name     in contacts.last_name%type,
        in_first_name    in contacts.first_name%type,
        in_salutation_id in contacts.salutation_id%type,
        in_email         in contacts.email%type,
        in_phone         in contacts.phone%type,
        in_linkedin_slug in contacts.linkedin_slug%type,
        in_note_text     in contacts.note_text%type
    );

    /**
     * Supprime un contact. Tout ou rien : si la suppression est refusée, ses
     * postes supprimés sont rétablis.
     * @param in_delete_positions true : supprime aussi ses postes ;
     *        false : refuse la suppression s'il en a
     * @throws app_errors.co_not_found contact inexistant
     * @throws app_errors.co_row_referenced contact qui a des postes (sans
     *         in_delete_positions), ou encore référencé par d'autres données
     */
    procedure delete_contact (
        in_contact_id       in contacts.contact_id%type,
        in_delete_positions in boolean default false
    );

    /**
     * Crée un poste du contact dans une entreprise.
     * @param in_is_current true : poste actuel
     * @return identifiant du poste
     */
    function create_position (
        in_contact_id in contact_positions.contact_id%type,
        in_company_id in contact_positions.company_id%type,
        in_job_id     in contact_positions.job_id%type,
        in_is_current in contact_positions.is_current%type
    ) return contact_positions.contact_position_id%type;

    /**
     * Remplace l'entreprise, le poste et l'indicateur d'un poste du contact, et
     * met à jour updated_at. Le contact ne change pas.
     * @throws app_errors.co_not_found poste inexistant
     */
    procedure update_position (
        in_contact_position_id in contact_positions.contact_position_id%type,
        in_company_id          in contact_positions.company_id%type,
        in_job_id              in contact_positions.job_id%type,
        in_is_current          in contact_positions.is_current%type
    );

    /**
     * Supprime un poste du contact.
     * @throws app_errors.co_not_found poste inexistant
     */
    procedure delete_position (
        in_contact_position_id in contact_positions.contact_position_id%type
    );

end contact_api;
/


create or replace package jobtracker.contact_api authid definer is
    /**
     * Écritures sur les contacts : point d'entrée unique, appelé par APEX.
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
     * Supprime un contact.
     * @throws app_errors.co_not_found contact inexistant
     */
    procedure delete_contact (
        in_contact_id in contacts.contact_id%type
    );

end contact_api;
/


-- sqlcl_snapshot {"hash":"214aa39fa9c29c86a5117af33557e6b68cd20ace","type":"PACKAGE_SPEC","name":"CONTACT_API","schemaName":"JOBTRACKER","sxml":""}
-- liquibase formatted sql
-- changeset JOBTRACKER:1793796994199 stripComments:false  logicalFilePath:feat/contact-positions/jobtracker/package_specs/company_api.sql
-- sqlcl_snapshot src/database/jobtracker/package_specs/company_api.sql:532c3e0c74a43c1acba737eeb8a3c3426a26aa70:08abf08e638d8b5ad08e4b08f3e4eab5cc63bd53:alter

create or replace package jobtracker.company_api authid definer is
    /**
     * Écritures sur les entreprises : point d'entrée unique, appelé par APEX.
     * Aucun COMMIT : la transaction appartient à l'appelant.
     * Les contraintes de la table restent la dernière ligne de défense : un
     * SIREN mal formé ou en double remonte en erreur Oracle.
     */

    /**
     * Crée une entreprise.
     * @return identifiant de l'entreprise
     */
    function create_company (
        in_company_name      in companies.company_name%type,
        in_description       in companies.description%type default null,
        in_note_text         in companies.note_text%type default null,
        in_parent_company_id in companies.parent_company_id%type default null,
        in_company_type_id   in companies.company_type_id%type default null,
        in_sector_id         in companies.sector_id%type default null,
        in_company_size_id   in companies.company_size_id%type default null,
        in_location_id       in companies.location_id%type default null,
        in_siren             in companies.siren%type default null,
        in_website_url       in companies.website_url%type default null,
        in_linkedin_slug     in companies.linkedin_slug%type default null,
        in_email             in companies.email%type default null,
        in_phone             in companies.phone%type default null,
        in_creation_year     in companies.creation_year%type default null
    ) return companies.company_id%type;

    /**
     * Remplace toutes les données d'une entreprise et met à jour updated_at.
     * Aucun paramètre n'a de valeur par défaut : null efface la colonne.
     * @throws app_errors.co_not_found entreprise inexistante
     * @throws app_errors.co_circular_reference parent qui créerait un cycle
     */
    procedure update_company (
        in_company_id        in companies.company_id%type,
        in_company_name      in companies.company_name%type,
        in_description       in companies.description%type,
        in_note_text         in companies.note_text%type,
        in_parent_company_id in companies.parent_company_id%type,
        in_company_type_id   in companies.company_type_id%type,
        in_sector_id         in companies.sector_id%type,
        in_company_size_id   in companies.company_size_id%type,
        in_location_id       in companies.location_id%type,
        in_siren             in companies.siren%type,
        in_website_url       in companies.website_url%type,
        in_linkedin_slug     in companies.linkedin_slug%type,
        in_email             in companies.email%type,
        in_phone             in companies.phone%type,
        in_creation_year     in companies.creation_year%type
    );

    /**
     * Supprime une entreprise. Tout ou rien : si la suppression est refusée,
     * les postes supprimés sont rétablis.
     * @param in_delete_positions true : supprime aussi les postes de ses
     *        contacts ; false : refuse la suppression si elle en a
     * @throws app_errors.co_not_found entreprise inexistante
     * @throws app_errors.co_row_referenced entreprise qui a des postes (sans
     *         in_delete_positions), ou encore référencée (filiale...)
     */
    procedure delete_company (
        in_company_id       in companies.company_id%type,
        in_delete_positions in boolean default false
    );

end company_api;
/


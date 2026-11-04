-- liquibase formatted sql
-- changeset JOBTRACKER:1793795578267 stripComments:false  logicalFilePath:feat/job-lookup/jobtracker/package_specs/job_api.sql
-- sqlcl_snapshot src/database/jobtracker/package_specs/job_api.sql:null:282d36451a63c3ff4bf4d0a99c52a5f6891d9e86:create

create or replace package jobtracker.job_api authid definer is
    /**
     * Écritures sur le référentiel des postes : point d'entrée unique, appelé
     * par APEX. Aucun COMMIT : la transaction appartient à l'appelant.
     * Un libellé est unique dans sa langue sans tenir compte de la casse.
     */

    /**
     * Crée un poste.
     * @return identifiant du poste
     * @throws app_errors.co_duplicate_value libellé déjà présent dans sa langue
     */
    function create_job (
        in_job_name_en in jobs.job_name_en%type,
        in_job_name_fr in jobs.job_name_fr%type
    ) return jobs.job_id%type;

    /**
     * Remplace les libellés d'un poste.
     * @throws app_errors.co_not_found poste inexistant
     * @throws app_errors.co_duplicate_value libellé déjà présent dans sa langue
     */
    procedure update_job (
        in_job_id      in jobs.job_id%type,
        in_job_name_en in jobs.job_name_en%type,
        in_job_name_fr in jobs.job_name_fr%type
    );

    /**
     * Supprime un poste.
     * @throws app_errors.co_not_found poste inexistant
     */
    procedure delete_job (
        in_job_id in jobs.job_id%type
    );

end job_api;
/


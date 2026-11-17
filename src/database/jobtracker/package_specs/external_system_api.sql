create or replace package jobtracker.external_system_api authid definer is
    /**
     * Écritures sur le référentiel des systèmes externes : point d'entrée
     * unique, appelé par APEX. Aucun COMMIT : la transaction appartient à
     * l'appelant. Ni création ni suppression : un système va de pair avec une
     * constante de exchange_log et s'ajoute par une migration.
     */

    /**
     * Remplace les paramètres du journal des échanges d'un système. Les bornes
     * sont portées par les contraintes de la table (ORA-02290), traduites par
     * app_error_handler.
     * @param in_retention_days       rétention des échanges, en jours
     * @param in_orphan_delay_minutes délai avant qu'un échange PENDING soit
     *                                abandonné, en minutes
     * @param in_is_exchange_logged   false pour ne plus journaliser le système
     * @throws app_errors.co_not_found système inexistant
     */
    procedure update_external_system (
        in_external_system_id   in external_systems.external_system_id%type,
        in_retention_days       in external_systems.retention_days%type,
        in_orphan_delay_minutes in external_systems.orphan_delay_minutes%type,
        in_is_exchange_logged   in external_systems.is_exchange_logged%type
    );

end external_system_api;
/


-- sqlcl_snapshot {"hash":"438dbe43c1a5fcda0411368d6958d561c4500aea","type":"PACKAGE_SPEC","name":"EXTERNAL_SYSTEM_API","schemaName":"JOBTRACKER","sxml":""}
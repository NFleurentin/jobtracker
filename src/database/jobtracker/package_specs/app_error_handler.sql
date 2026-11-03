create or replace package jobtracker.app_error_handler authid definer is
    /**
     * Traduction des erreurs de l'application APEX en messages pour l'utilisateur.
     * Une contrainte nouvelle dont le message doit être lisible s'ajoute dans le body.
     */

    /**
     * Error Handling Function de l'application : laisse passer les erreurs
     * prévues par APEX et les validations, affiche les erreurs métier sans leur
     * préfixe Oracle, les contraintes et la modification concurrente traduites,
     * masque et journalise le reste.
     * Le nom de p_error et son type sont ceux de la signature documentée par APEX.
     * @param p_error erreur transmise par APEX
     * @return message et emplacement d'affichage
     */
    function handle_error (
        p_error in apex_error.t_error
    ) return apex_error.t_error_result;

end app_error_handler;
/


-- sqlcl_snapshot {"hash":"8bbdbc70acf9ecf00d6d4ad1cbf32f7b883c8cc0","type":"PACKAGE_SPEC","name":"APP_ERROR_HANDLER","schemaName":"JOBTRACKER","sxml":""}
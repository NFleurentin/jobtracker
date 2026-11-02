create or replace package jobtracker.app_error_handler authid definer is
    /**
     * Traduction des erreurs de l'application APEX en messages pour l'utilisateur.
     * Une contrainte nouvelle dont le message doit être lisible s'ajoute dans le body.
     */

    /**
     * Error Handling Function de l'application : laisse passer les erreurs
     * prévues par APEX et les validations, affiche les erreurs métier sans leur
     * préfixe Oracle et les contraintes traduites, masque et journalise le reste.
     * Le nom de p_error et son type sont ceux de la signature documentée par APEX.
     * @param p_error erreur transmise par APEX
     * @return message et emplacement d'affichage
     */
    function handle_error (
        p_error in apex_error.t_error
    ) return apex_error.t_error_result;

end app_error_handler;
/


-- sqlcl_snapshot {"hash":"3695a35bd945e351ac691ca7a1073d2c8585b8a5","type":"PACKAGE_SPEC","name":"APP_ERROR_HANDLER","schemaName":"JOBTRACKER","sxml":""}
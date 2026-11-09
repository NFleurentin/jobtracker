comment on table jobtracker.application_status_changes is
    'Historique des statuts d''une candidature, dont le statut initial. changed_at est modifiable pour une saisie a posteriori ; à changed_at égal, l''identifiant départage. Supprimé avec la candidature ; application_api refuse de supprimer son dernier changement.'
    ;


-- sqlcl_snapshot {"hash":"30ccf9f48613abb7908f11efa5624a19c6845647","type":"COMMENT","name":"APPLICATION_STATUS_CHANGES","schemaName":"jobtracker","sxml":""}
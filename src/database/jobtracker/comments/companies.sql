comment on table jobtracker.companies is
    'Entreprises suivies : employeurs, ESN, cabinets, clients. Écritures par le package, qui met à jour updated_at et refuse les cycles sur parent_company_id. is_generic marque l''entreprise générique « Confidentielle », destinataire d''une candidature sans entreprise connue : créée par migration, modifiable mais pas supprimable.'
    ;


-- sqlcl_snapshot {"hash":"406ad219fee30c2a4f770a5f5175247807f541e3","type":"COMMENT","name":"COMPANIES","schemaName":"jobtracker","sxml":""}
comment on table jobtracker.ft_contract_types is
    'Types de contrat du référentiel France Travail (/referentiel/typesContrats), chargés depuis l''API. Distinct de contract_types, saisi à la main.'
    ;

comment on column jobtracker.ft_contract_types.ft_referential_load_id is
    'Dernier chargement qui a reçu ce code. Le code a disparu de l''API si cet identifiant est inférieur au plus grand de la table (règle portée par ft_contract_type_details).'
    ;


-- sqlcl_snapshot {"hash":"cd121f3549b2205d3fa5fa5b86bd47a9ddff7db0","type":"COMMENT","name":"FT_CONTRACT_TYPES","schemaName":"jobtracker","sxml":""}
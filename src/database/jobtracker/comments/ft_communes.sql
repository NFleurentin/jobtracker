comment on table jobtracker.ft_communes is
    'Communes du référentiel France Travail (/referentiel/communes), chargées depuis l''API après les départements. Homonymes possibles, jamais dans un même département.'
    ;

comment on column jobtracker.ft_communes.commune_code is
    'Code INSEE de la commune.';

comment on column jobtracker.ft_communes.department_code is
    'Département de la commune ; nul si l''API la rattache à un code absent de ft_departments (anomalie consignée dans le chargement).'
    ;

comment on column jobtracker.ft_communes.ft_referential_load_id is
    'Dernier chargement qui a reçu ce code. Le code a disparu de l''API si cet identifiant est inférieur au plus grand de la table (règle portée par ft_commune_details).'
    ;

comment on column jobtracker.ft_communes.postal_code is
    'Code postal, pour l''affichage seulement : parfois nul ou partiel dans l''API.';


-- sqlcl_snapshot {"hash":"e80d772bb8452915ae1d1851ee8a4366431fd832","type":"COMMENT","name":"FT_COMMUNES","schemaName":"jobtracker","sxml":""}
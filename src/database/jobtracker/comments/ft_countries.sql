comment on table jobtracker.ft_countries is
    'Pays du référentiel France Travail (/referentiel/pays), chargés depuis l''API.';

comment on column jobtracker.ft_countries.ft_referential_load_id is
    'Dernier chargement qui a reçu ce code. Le code a disparu de l''API si cet identifiant est inférieur au plus grand de la table (règle portée par ft_country_details).'
    ;


-- sqlcl_snapshot {"hash":"0d33b7c4266d976a8e14f19e0eada9fd28962f03","type":"COMMENT","name":"FT_COUNTRIES","schemaName":"jobtracker","sxml":""}
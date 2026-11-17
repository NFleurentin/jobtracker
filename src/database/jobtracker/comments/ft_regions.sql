comment on table jobtracker.ft_regions is
    'Régions du référentiel France Travail (/referentiel/regions), chargées depuis l''API. Libellé unique, en français, non traduit.'
    ;

comment on column jobtracker.ft_regions.ft_referential_load_id is
    'Dernier chargement qui a reçu ce code. Le code a disparu de l''API si cet identifiant est inférieur au plus grand de la table (règle portée par ft_region_details).'
    ;


-- sqlcl_snapshot {"hash":"4d3feac5f01e074a32a34427d26f426827e68019","type":"COMMENT","name":"FT_REGIONS","schemaName":"jobtracker","sxml":""}
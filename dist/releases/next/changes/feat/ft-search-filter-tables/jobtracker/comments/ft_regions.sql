-- liquibase formatted sql
-- changeset jobtracker:1794922337797 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/comments/ft_regions.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ft_regions.sql:null:4d3feac5f01e074a32a34427d26f426827e68019:create

comment on table jobtracker.ft_regions is
    'Régions du référentiel France Travail (/referentiel/regions), chargées depuis l''API. Libellé unique, en français, non traduit.'
    ;

comment on column jobtracker.ft_regions.ft_referential_load_id is
    'Dernier chargement qui a reçu ce code. Le code a disparu de l''API si cet identifiant est inférieur au plus grand de la table (règle portée par ft_region_details).'
    ;


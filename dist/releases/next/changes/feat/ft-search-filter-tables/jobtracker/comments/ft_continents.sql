-- liquibase formatted sql
-- changeset jobtracker:1794922337759 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/comments/ft_continents.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ft_continents.sql:null:e030c8033d391d77af57de26397898bf144a7a53:create

comment on table jobtracker.ft_continents is
    'Continents du référentiel France Travail (/referentiel/continents), chargés depuis l''API.';

comment on column jobtracker.ft_continents.ft_referential_load_id is
    'Dernier chargement qui a reçu ce code. Le code a disparu de l''API si cet identifiant est inférieur au plus grand de la table (règle portée par ft_continent_details).'
    ;


-- liquibase formatted sql
-- changeset jobtracker:1794922337773 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/comments/ft_countries.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ft_countries.sql:null:0d33b7c4266d976a8e14f19e0eada9fd28962f03:create

comment on table jobtracker.ft_countries is
    'Pays du référentiel France Travail (/referentiel/pays), chargés depuis l''API.';

comment on column jobtracker.ft_countries.ft_referential_load_id is
    'Dernier chargement qui a reçu ce code. Le code a disparu de l''API si cet identifiant est inférieur au plus grand de la table (règle portée par ft_country_details).'
    ;


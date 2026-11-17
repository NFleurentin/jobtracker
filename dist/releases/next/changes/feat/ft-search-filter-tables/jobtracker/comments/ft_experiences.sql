-- liquibase formatted sql
-- changeset jobtracker:1794922337776 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/comments/ft_experiences.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ft_experiences.sql:null:2eaf347cba9e5c68fc360a695e4ddf7b2face65a:create

comment on table jobtracker.ft_experiences is
    'Valeurs du paramètre experience de la recherche d''offres France Travail. Liste fixe chargée par migration (pas d''endpoint de référentiel).'
    ;


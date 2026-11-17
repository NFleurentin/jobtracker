-- liquibase formatted sql
-- changeset jobtracker:1794922337788 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/comments/ft_experience_requirements.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ft_experience_requirements.sql:null:5afe81d24510c0adf8220bdc0921ec573511308f:create

comment on table jobtracker.ft_experience_requirements is
    'Valeurs du paramètre experienceExigence de la recherche d''offres France Travail. Liste fixe chargée par migration (pas d''endpoint de référentiel).'
    ;


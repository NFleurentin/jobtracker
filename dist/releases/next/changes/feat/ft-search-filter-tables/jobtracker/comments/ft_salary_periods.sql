-- liquibase formatted sql
-- changeset jobtracker:1794922337793 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/comments/ft_salary_periods.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ft_salary_periods.sql:null:caaceae5a43ca7fc7f229e082a25f346085b6a22:create

comment on table jobtracker.ft_salary_periods is
    'Valeurs du paramètre periodeSalaire de la recherche d''offres France Travail. Liste fixe chargée par migration (pas d''endpoint de référentiel).'
    ;


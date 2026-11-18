-- liquibase formatted sql
-- changeset jobtracker:1794994602474 stripComments:false  logicalFilePath:feat/offer-search-filters/jobtracker/comments/ft_posting_periods.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ft_posting_periods.sql:null:1fcb65d40b13547fe7c8bf293b8666a72a3f8175:create

comment on table jobtracker.ft_posting_periods is
    'Valeurs du paramètre publieeDepuis de la recherche d''offres France Travail : nombre de jours maximal depuis la publication. Liste fixe chargée par migration (pas d''endpoint de référentiel) ; toute autre valeur est refusée par l''API (constaté le 18/11/2026).'
    ;


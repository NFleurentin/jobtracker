-- liquibase formatted sql
-- changeset jobtracker:1794922337785 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/comments/ft_offer_origins.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ft_offer_origins.sql:null:e5ab8cc87491f48dd396d91788c7063099597d7a:create

comment on table jobtracker.ft_offer_origins is
    'Valeurs du paramètre origineOffre de la recherche d''offres France Travail. Liste fixe chargée par migration (pas d''endpoint de référentiel).'
    ;


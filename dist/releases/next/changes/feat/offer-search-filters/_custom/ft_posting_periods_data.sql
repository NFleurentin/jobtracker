-- liquibase formatted sql
-- changeset  SqlCl:1794994572376 stripComments:false logicalFilePath:_custom/ft_posting_periods_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/offer-search-filters/_custom/ft_posting_periods_data.sql:null:null:custom



-- =============================================================================
-- ft_posting_periods_data.sql : valeurs du paramètre publieeDepuis de la
-- recherche d'offres France Travail, sans endpoint de référentiel (#165).
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Valeurs constatées sur l'API le 18/11/2026 (la documentation dit seulement
-- « entier ») : toute autre valeur rend une erreur 400.
-- Rejouable : une valeur déjà présente n'est pas modifiée.
-- =============================================================================
insert into ft_posting_periods ( posting_period_code, posting_period_name )
select v.code, v.name
from ( values ( '1', '1 jour' ),
              ( '3', '3 jours' ),
              ( '7', '7 jours' ),
              ( '14', '14 jours' ),
              ( '31', '31 jours' ) ) v ( code, name )
where not exists ( select null from ft_posting_periods t where t.posting_period_code = v.code );

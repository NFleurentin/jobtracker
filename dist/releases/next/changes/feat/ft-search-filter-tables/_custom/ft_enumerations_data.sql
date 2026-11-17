-- liquibase formatted sql
-- changeset  SqlCl:1794922264901 stripComments:false logicalFilePath:_custom/ft_enumerations_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/ft-search-filter-tables/_custom/ft_enumerations_data.sql:null:null:custom






-- =============================================================================
-- ft_enumerations_data.sql : valeurs des énumérations de la recherche
-- d'offres France Travail, sans endpoint de référentiel (#156).
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Valeurs tirées de la documentation de l'API Offres d'emploi v2.
-- Rejouable : une valeur déjà présente n'est pas modifiée.
-- =============================================================================
insert into ft_experiences ( experience_code, experience_name )
select v.code, v.name
from ( values ( '1', 'Moins d''un an' ),
              ( '2', 'De 1 à 3 ans' ),
              ( '3', 'Plus de 3 ans' ) ) v ( code, name )
where not exists ( select null from ft_experiences t where t.experience_code = v.code );

insert into ft_experience_requirements ( experience_requirement_code, experience_requirement_name )
select v.code, v.name
from ( values ( 'D', 'Débutant accepté' ),
              ( 'S', 'Expérience souhaitée' ),
              ( 'E', 'Expérience exigée' ) ) v ( code, name )
where not exists ( select null from ft_experience_requirements t where t.experience_requirement_code = v.code );

insert into ft_salary_periods ( salary_period_code, salary_period_name )
select v.code, v.name
from ( values ( 'M', 'Mensuel' ),
              ( 'A', 'Annuel' ),
              ( 'H', 'Horaire' ),
              ( 'C', 'Cachet' ) ) v ( code, name )
where not exists ( select null from ft_salary_periods t where t.salary_period_code = v.code );

insert into ft_offer_origins ( offer_origin_code, offer_origin_name )
select v.code, v.name
from ( values ( '1', 'France Travail' ),
              ( '2', 'Partenaire' ) ) v ( code, name )
where not exists ( select null from ft_offer_origins t where t.offer_origin_code = v.code );

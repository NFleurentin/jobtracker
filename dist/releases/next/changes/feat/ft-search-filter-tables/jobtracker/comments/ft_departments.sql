-- liquibase formatted sql
-- changeset jobtracker:1794922337765 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/comments/ft_departments.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ft_departments.sql:null:4887d2a710e04168c436cdd197daa7da9e95d69a:create

comment on table jobtracker.ft_departments is
    'Départements du référentiel France Travail (/referentiel/departements), chargés depuis l''API après les régions.';

comment on column jobtracker.ft_departments.ft_referential_load_id is
    'Dernier chargement qui a reçu ce code. Le code a disparu de l''API si cet identifiant est inférieur au plus grand de la table (règle portée par ft_department_details).'
    ;

comment on column jobtracker.ft_departments.region_code is
    'Région du département ; nulle si l''API la rattache à un code absent de ft_regions (anomalie consignée dans le chargement).';


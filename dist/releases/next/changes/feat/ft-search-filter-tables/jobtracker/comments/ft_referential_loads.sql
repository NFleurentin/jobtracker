-- liquibase formatted sql
-- changeset jobtracker:1794922337782 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/comments/ft_referential_loads.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ft_referential_loads.sql:null:989f857a51d289fd96ba260b2e1ff507b8d45d44:create

comment on table jobtracker.ft_referential_loads is
    'Chargements des référentiels de France Travail depuis l''API : une ligne par chargement, tous référentiels confondus. Non purgée (peu de lignes).'
    ;

comment on column jobtracker.ft_referential_loads.ended_at is
    'Fin du chargement ; nulle tant qu''il tourne, avec le statut. Un chargement en cours se déduit de la présence du job.';

comment on column jobtracker.ft_referential_loads.load_details is
    'Détail par référentiel : statut, lignes reçues et devenues non courantes, message d''erreur, anomalies (commune ou département rattaché à un code inconnu).'
    ;

comment on column jobtracker.ft_referential_loads.load_status is
    'SUCCESS : tous les référentiels chargés ; PARTIAL : au moins un en échec et au moins un chargé ; ERROR : tous en échec, ou échec avant le premier.'
    ;


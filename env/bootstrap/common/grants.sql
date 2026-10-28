-- =============================================================================
-- grants.sql : droits du schéma applicatif sur Logger
-- Les synonymes privés de JOBTRACKER vers Logger sont des objets du schéma
-- applicatif : ils viennent d'une migration, pas de l'amorçage.
--
-- Joué par l'administrateur, après l'installation de Logger. Rejouable.
-- =============================================================================
grant execute on logger.logger to jobtracker;
grant select on logger.logger_logs to jobtracker;

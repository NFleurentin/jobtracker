-- liquibase formatted sql
-- changeset JOBTRACKER:1793212579430 stripComments:false  logicalFilePath:feat/collect-france-travail-api/jobtracker/synonyms/logger_logs.sql
-- sqlcl_snapshot src/database/jobtracker/synonyms/logger_logs.sql:null:7be3c6f0be519bb6816cd20fe02693d7ba305f59:create

create or replace editionable synonym jobtracker.logger_logs for logger.logger_logs;


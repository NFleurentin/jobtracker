-- liquibase formatted sql
-- changeset JOBTRACKER:1793212579433 stripComments:false  logicalFilePath:feat/collect-france-travail-api/jobtracker/synonyms/logger.sql
-- sqlcl_snapshot src/database/jobtracker/synonyms/logger.sql:null:7e7c88ae1322239b7ac8498a6bcb43349ecfbb3a:create

create or replace editionable synonym jobtracker.logger for logger.logger;


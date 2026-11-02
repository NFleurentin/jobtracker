-- liquibase formatted sql
-- changeset jobtracker:1793627616444 stripComments:false  logicalFilePath:feat/company-management/jobtracker/comments/location_types.sql
-- sqlcl_snapshot src/database/jobtracker/comments/location_types.sql:null:d852314f625cc1cd0bfa7dc34330648a773ce697:create

comment on table jobtracker.location_types is
    'Types de lieu, du pays à l''adresse. Le code distingue des lieux de même code officiel : 01 est à la fois une région et un département.'
    ;


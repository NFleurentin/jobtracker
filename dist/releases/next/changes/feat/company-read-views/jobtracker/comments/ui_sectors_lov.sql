-- liquibase formatted sql
-- changeset jobtracker:1793700751700 stripComments:false  logicalFilePath:feat/company-read-views/jobtracker/comments/ui_sectors_lov.sql
-- sqlcl_snapshot src/database/jobtracker/comments/ui_sectors_lov.sql:null:b3a61a8f7e112b2211a4cd2e9902ffbf6cc4460e:create

comment on table jobtracker.ui_sectors_lov is
    'Liste de valeurs des secteurs d''activité (APEX).';


-- liquibase formatted sql
-- changeset jobtracker:1793628055907 stripComments:false  logicalFilePath:feat/company-management/jobtracker/comments/locations.sql
-- sqlcl_snapshot src/database/jobtracker/comments/locations.sql:null:ffcdb02052aa01783ba91f505befa44f92120b35:create

comment on table jobtracker.locations is
    'Lieux, hiérarchisés du pays à l''adresse. Le code officiel (INSEE) n''identifie un lieu qu''avec son type.';


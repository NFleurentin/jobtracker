-- liquibase formatted sql
-- changeset jobtracker:1793795578260 stripComments:false  logicalFilePath:feat/job-lookup/jobtracker/comments/jobs.sql
-- sqlcl_snapshot src/database/jobtracker/comments/jobs.sql:null:b5d332e709c4ea212517079cff77a37ed8b8bfde:create

comment on table jobtracker.jobs is
    'Postes occupés par les contacts (recruteur, manager...), libellés en anglais et en français. Valeurs de départ chargées par migration, complétées par l''utilisateur. Écritures par le package job_api.'
    ;


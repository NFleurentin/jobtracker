-- liquibase formatted sql
-- changeset  SqlCl:1793795556952 stripComments:false logicalFilePath:_custom/jobs_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/job-lookup/_custom/jobs_data.sql:null:null:custom



-- =============================================================================
-- jobs_data.sql : postes de départ du référentiel des postes
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Rejouable : un poste dont le libellé anglais ou français existe déjà, sans
-- tenir compte de la casse, n'est ni inséré ni modifié. Les postes ajoutés ou
-- renommés par l'utilisateur sont donc conservés.
-- =============================================================================
insert into jobs (
    job_name_en,
    job_name_fr
)
select
    v.job_name_en,
    v.job_name_fr
from
    (
        values ( 'Recruiter', 'Recruteur' ),
               ( 'Talent acquisition specialist', 'Chargé de recrutement' ),
               ( 'HR manager', 'Responsable RH' ),
               ( 'Hiring manager', 'Manager recruteur' ),
               ( 'Team lead', 'Responsable d''équipe' ),
               ( 'Engineering manager', 'Responsable technique' ),
               ( 'CTO', 'Directeur technique' ),
               ( 'CEO', 'Dirigeant' ),
               ( 'Account manager', 'Ingénieur d''affaires' ),
               ( 'Tech lead', 'Tech lead' )
    ) v ( job_name_en, job_name_fr )
where
    not exists (
        select
            null
        from
            jobs j
        where
            upper(j.job_name_en) = upper(v.job_name_en)
            or upper(j.job_name_fr) = upper(v.job_name_fr)
    );

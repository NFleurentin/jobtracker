-- liquibase formatted sql
-- changeset  SqlCl:1794409965050 stripComments:false logicalFilePath:_custom/work_modes_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/work-modes/_custom/work_modes_data.sql:null:null:custom



-- =============================================================================
-- work_modes_data.sql : référentiel des modes de travail
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Liste fixe, sans écran de maintenance : le code est la clé des packages.
-- Rejouable : un mode déjà présent n'est pas modifié.
-- =============================================================================
insert into work_modes (
    work_mode_code,
    work_mode_name_fr,
    work_mode_name_en
)
select
    v.work_mode_code,
    v.work_mode_name_fr,
    v.work_mode_name_en
from
    (
        values ( 'ON_SITE', 'Présentiel', 'On-site' ),
               ( 'HYBRID', 'Hybride', 'Hybrid' ),
               ( 'FULL_REMOTE', 'Télétravail complet', 'Full remote' )
    ) v ( work_mode_code, work_mode_name_fr, work_mode_name_en )
where
    not exists (
        select
            null
        from
            work_modes t
        where
            t.work_mode_code = v.work_mode_code
    );

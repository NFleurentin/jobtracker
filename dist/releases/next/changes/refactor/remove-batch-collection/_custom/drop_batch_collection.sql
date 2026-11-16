-- liquibase formatted sql
-- changeset  SqlCl:1794841347997 stripComments:false logicalFilePath:_custom/drop_batch_collection.sql
-- sqlcl_snapshot dist/releases/next/changes/refactor/remove-batch-collection/_custom/drop_batch_collection.sql:null:null:custom

-- =============================================================================
-- drop_batch_collection.sql : suppression de la collecte par lots
--
-- project stage génère la suppression d'un objet en commentaire, et réécrit
-- le changeset si on le décommente : les DROP sont faits ici. Packages
-- d'abord, puis la table enfant avant sa parente (clé étrangère
-- collect_requests_collect_runs_fk) ; index, contraintes et commentaires
-- partent avec leur table. offer_sources est conservée.
-- Rejouable : un objet déjà absent est ignoré.
-- =============================================================================
declare
    type t_drops is
        table of varchar2(100 char);
    -- Dans l'ordre d'exécution
    co_drops constant t_drops := t_drops(
        'package collect_france_travail',
        'package collect_staging',
        'table collect_requests purge',
        'table collect_runs purge'
    );
    -- ORA-04043 : package inexistant
    e_package_not_exists exception;
    pragma exception_init ( e_package_not_exists, -4043 );
    -- ORA-00942 : table inexistante
    e_table_not_exists exception;
    pragma exception_init ( e_table_not_exists, -942 );
begin
    for i in 1..co_drops.count loop
        begin
            execute immediate 'drop ' || co_drops(i);
        exception
            when e_package_not_exists or e_table_not_exists then
                null;
        end;
    end loop;
end;
/

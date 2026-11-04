-- liquibase formatted sql
-- changeset  SqlCl:1793795556680 stripComments:false logicalFilePath:_custom/jobs_messages_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/job-lookup/_custom/jobs_messages_data.sql:null:null:custom



-- =============================================================================
-- jobs_messages_data.sql : messages du référentiel des postes
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Rejouable : un message présent prend le texte du dépôt (voir
-- app_messages_data.sql).
-- =============================================================================
merge into app_messages m
using (
    values ( 'JOB_DUPLICATE', 'fr', 'Le poste « {1} » existe déjà.' )
) v ( message_key, language_code, message_text )
on ( m.message_key = v.message_key
     and m.language_code = v.language_code )
when matched then
    update set m.message_text = v.message_text
     where m.message_text <> v.message_text
when not matched then
    insert ( message_key, language_code, message_text )
    values ( v.message_key, v.language_code, v.message_text );

-- liquibase formatted sql
-- changeset  SqlCl:1794900698821 stripComments:false logicalFilePath:_custom/external_systems_messages_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/external-systems-settings/_custom/external_systems_messages_data.sql:null:null:custom



-- =============================================================================
-- external_systems_messages_data.sql : messages des systèmes externes
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Rejouable : un message présent prend le texte du dépôt (voir
-- app_messages_data.sql).
-- =============================================================================
merge into app_messages m
using (
    values ( 'EXTERNAL_SYSTEMS_RETENTION_DAYS_CK', 'fr', 'La rétention doit être comprise entre 1 et 7 jours.' ),
           ( 'EXTERNAL_SYSTEMS_ORPHAN_DELAY_MINUTES_CK', 'fr', 'Le délai des échanges orphelins doit être compris entre 5 et 1440 minutes.' )
) v ( message_key, language_code, message_text )
on ( m.message_key = v.message_key
     and m.language_code = v.language_code )
when matched then
    update set m.message_text = v.message_text
     where m.message_text <> v.message_text
when not matched then
    insert ( message_key, language_code, message_text )
    values ( v.message_key, v.language_code, v.message_text );

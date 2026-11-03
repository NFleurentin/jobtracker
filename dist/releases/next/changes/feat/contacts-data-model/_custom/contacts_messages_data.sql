-- liquibase formatted sql
-- changeset  SqlCl:1793737922987 stripComments:false logicalFilePath:_custom/contacts_messages_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/contacts-data-model/_custom/contacts_messages_data.sql:null:null:custom



-- =============================================================================
-- contacts_messages_data.sql : messages des contraintes des contacts
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Rejouable : un message présent prend le texte du dépôt (voir
-- app_messages_data.sql).
-- =============================================================================
merge into app_messages m
using (
    values ( 'CONTACTS_LINKEDIN_SLUG_CK', 'fr', 'L''identifiant LinkedIn ne doit contenir ni barre oblique ni espace.' )
) v ( message_key, language_code, message_text )
on ( m.message_key = v.message_key
     and m.language_code = v.language_code )
when matched then
    update set m.message_text = v.message_text
     where m.message_text <> v.message_text
when not matched then
    insert ( message_key, language_code, message_text )
    values ( v.message_key, v.language_code, v.message_text );

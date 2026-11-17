-- liquibase formatted sql
-- changeset  SqlCl:1794932787733 stripComments:false logicalFilePath:_custom/ft_referential_loader_messages_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/load-france-travail-referentials/_custom/ft_referential_loader_messages_data.sql:null:null:custom



-- =============================================================================
-- ft_referential_loader_messages_data.sql : messages du chargement des
-- référentiels France Travail
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Rejouable : un message présent prend le texte du dépôt (voir
-- app_messages_data.sql).
-- =============================================================================
merge into app_messages m
using (
    values ( 'FT_REFERENTIAL_LOAD_RUNNING', 'fr', 'Un chargement des référentiels France Travail est déjà en cours.' )
) v ( message_key, language_code, message_text )
on ( m.message_key = v.message_key
     and m.language_code = v.language_code )
when matched then
    update set m.message_text = v.message_text
     where m.message_text <> v.message_text
when not matched then
    insert ( message_key, language_code, message_text )
    values ( v.message_key, v.language_code, v.message_text );

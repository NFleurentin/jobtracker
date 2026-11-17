-- liquibase formatted sql
-- changeset  SqlCl:1794949366673 stripComments:false logicalFilePath:_custom/ft_referential_load_states_messages_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/apex-reload-ft-referentials/_custom/ft_referential_load_states_messages_data.sql:null:null:custom






-- =============================================================================
-- ft_referential_load_states_messages_data.sql : libellés des états d'un
-- chargement des référentiels France Travail (ui_ft_referential_loads_last)
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Rejouable : un message présent prend le texte du dépôt (voir
-- app_messages_data.sql).
-- =============================================================================
merge into app_messages m
using (
    values ( 'FT_REFERENTIAL_LOAD_STATE_RUNNING', 'fr', 'En cours' ),
           ( 'FT_REFERENTIAL_LOAD_STATE_SUCCESS', 'fr', 'Terminé' ),
           ( 'FT_REFERENTIAL_LOAD_STATE_PARTIAL', 'fr', 'Terminé avec des erreurs' ),
           ( 'FT_REFERENTIAL_LOAD_STATE_ERROR', 'fr', 'Échec' ),
           ( 'FT_REFERENTIAL_LOAD_STATE_INTERRUPTED', 'fr', 'Interrompu' )
) v ( message_key, language_code, message_text )
on ( m.message_key = v.message_key
     and m.language_code = v.language_code )
when matched then
    update set m.message_text = v.message_text
     where m.message_text <> v.message_text
when not matched then
    insert ( message_key, language_code, message_text )
    values ( v.message_key, v.language_code, v.message_text );

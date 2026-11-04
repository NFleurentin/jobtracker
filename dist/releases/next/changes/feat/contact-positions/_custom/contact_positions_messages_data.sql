-- liquibase formatted sql
-- changeset  SqlCl:1793796975942 stripComments:false logicalFilePath:_custom/contact_positions_messages_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/contact-positions/_custom/contact_positions_messages_data.sql:null:null:custom



-- =============================================================================
-- contact_positions_messages_data.sql : messages des postes des contacts
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Rejouable : un message présent prend le texte du dépôt (voir
-- app_messages_data.sql).
-- =============================================================================
merge into app_messages m
using (
    values ( 'CONTACT_POSITIONS_CONTACT_ID_COMPANY_ID_JOB_ID_UK', 'fr', 'Ce contact occupe déjà ce poste dans cette entreprise.' ),
           ( 'CONTACT_HAS_POSITIONS', 'fr', 'Le contact « {1} » occupe des postes dans des entreprises : supprimez-les avec le contact pour continuer.' ),
           ( 'COMPANY_HAS_POSITIONS', 'fr', 'Des contacts occupent des postes dans l''entreprise « {1} » : supprimez-les avec l''entreprise pour continuer.' ),
           ( 'CONTACT_ROW_REFERENCED', 'fr', 'Le contact « {1} » est référencé par d''autres données : suppression impossible.' ),
           ( 'JOB_ROW_REFERENCED', 'fr', 'Le poste « {1} » est occupé par des contacts : suppression impossible.' )
) v ( message_key, language_code, message_text )
on ( m.message_key = v.message_key
     and m.language_code = v.language_code )
when matched then
    update set m.message_text = v.message_text
     where m.message_text <> v.message_text
when not matched then
    insert ( message_key, language_code, message_text )
    values ( v.message_key, v.language_code, v.message_text );

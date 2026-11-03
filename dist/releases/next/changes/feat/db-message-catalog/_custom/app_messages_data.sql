-- liquibase formatted sql
-- changeset  SqlCl:1793716784256 stripComments:false logicalFilePath:_custom/app_messages_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/db-message-catalog/_custom/app_messages_data.sql:null:null:custom




-- =============================================================================
-- app_messages_data.sql : catalogue des messages affichés à l'utilisateur
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Rejouable : un message présent prend le texte du dépôt, contrairement aux
-- autres référentiels, car le catalogue n'est modifié que par le dépôt.
-- Un changeset joué ne se rejoue pas : un texte modifié ou ajouté plus tard
-- passe par un nouveau changeset de sa branche, avec les seules lignes en jeu.
-- =============================================================================
merge into app_messages m
using (
    values ( 'UNEXPECTED_ERROR', 'fr', 'Une erreur inattendue s''est produite. Elle a été journalisée.' ),
           ( 'DATA_HAS_CHANGED', 'fr', 'Ces données ont été modifiées entre-temps. Rechargez la page avant d''enregistrer.' ),
           ( 'COMPANIES_SIREN_UK', 'fr', 'Ce SIREN est déjà utilisé par une autre entreprise.' ),
           ( 'COMPANIES_SIREN_CK', 'fr', 'Le SIREN doit comporter exactement 9 chiffres.' ),
           ( 'COMPANIES_LINKEDIN_SLUG_CK', 'fr', 'L''identifiant LinkedIn ne doit contenir ni barre oblique ni espace.' ),
           ( 'COMPANY_CIRCULAR_REFERENCE', 'fr', '« {1} » ne peut pas avoir « {2} » comme entreprise parente : ce rattachement créerait un cycle.' ),
           ( 'COMPANY_ROW_REFERENCED', 'fr', 'L''entreprise « {1} » est référencée par d''autres données : suppression impossible.' )
) v ( message_key, language_code, message_text )
on ( m.message_key = v.message_key
     and m.language_code = v.language_code )
when matched then
    update set m.message_text = v.message_text
     where m.message_text <> v.message_text
when not matched then
    insert ( message_key, language_code, message_text )
    values ( v.message_key, v.language_code, v.message_text );

-- liquibase formatted sql
-- changeset  SqlCl:1794246044409 stripComments:false logicalFilePath:_custom/applications_messages_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/application-storage/_custom/applications_messages_data.sql:null:null:custom



-- =============================================================================
-- applications_messages_data.sql : messages des candidatures
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Rejouable : un message présent prend le texte du dépôt (voir
-- app_messages_data.sql).
-- =============================================================================
merge into app_messages m
using (
    values ( 'APPLICATIONS_ANNUAL_SALARY_PROPOSED_EUROS_CK', 'fr', 'Le salaire annuel proposé doit être positif.' ),
           ( 'APPLICATIONS_DAILY_RATE_PROPOSED_EUROS_CK', 'fr', 'Le TJM proposé doit être positif.' ),
           ( 'APPLICATIONS_INTEREST_RATING_CK', 'fr', 'L''intérêt est une note de 1 à 5.' ),
           ( 'APPLICATION_ALREADY_OPEN', 'fr', 'Une candidature est déjà ouverte pour l''entreprise « {1} » : clôturez-la avant d''en ouvrir une autre.' ),
           ( 'APPLICATION_LAST_STATUS_UNDELETABLE', 'fr', 'La candidature « {1} » n''a plus que ce statut : corrigez-le, ou supprimez la candidature.' ),
           ( 'APPLICATION_STATUS_NOT_LATEST', 'fr', 'Seul le statut le plus récent de la candidature « {1} » peut être corrigé ou annulé.' ),
           ( 'COMPANY_LOCKED', 'fr', 'L''entreprise « {1} » est en cours de modification par un autre traitement : réessayez dans quelques instants.' ),
           ( 'APPLICATION_LOCKED', 'fr', 'La candidature « {1} » est en cours de modification par un autre traitement : réessayez dans quelques instants.' ),
           ( 'APPLICATION_STATUS_BEFORE_PREVIOUS', 'fr', 'La date du statut de la candidature « {1} » doit rester postérieure à celle du statut précédent.' )
) v ( message_key, language_code, message_text )
on ( m.message_key = v.message_key
     and m.language_code = v.language_code )
when matched then
    update set m.message_text = v.message_text
     where m.message_text <> v.message_text
when not matched then
    insert ( message_key, language_code, message_text )
    values ( v.message_key, v.language_code, v.message_text );

-- liquibase formatted sql
-- changeset  SqlCl:1794994572645 stripComments:false logicalFilePath:_custom/offer_search_messages_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/offer-search-filters/_custom/offer_search_messages_data.sql:null:null:custom



-- =============================================================================
-- offer_search_messages_data.sql : messages de refus des filtres d'une
-- recherche d'offres (ft_offer_search)
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Rejouable : un message présent prend le texte du dépôt (voir
-- app_messages_data.sql).
-- =============================================================================
merge into app_messages m
using (
    values ( 'OFFER_SEARCH_DISTANCE_WITHOUT_COMMUNE', 'fr', 'Distance : ne s''applique qu''à une recherche par commune.' ),
           ( 'OFFER_SEARCH_BORDERING_WITHOUT_DEPARTMENT', 'fr', 'Départements limitrophes : ne s''appliquent qu''à une recherche par département.' ),
           ( 'OFFER_SEARCH_SALARY_WITHOUT_PERIOD', 'fr', 'Salaire minimum : préciser la période.' ),
           ( 'OFFER_SEARCH_PERIOD_WITHOUT_SALARY', 'fr', 'Période du salaire : préciser le salaire minimum.' )
) v ( message_key, language_code, message_text )
on ( m.message_key = v.message_key
     and m.language_code = v.language_code )
when matched then
    update set m.message_text = v.message_text
     where m.message_text <> v.message_text
when not matched then
    insert ( message_key, language_code, message_text )
    values ( v.message_key, v.language_code, v.message_text );

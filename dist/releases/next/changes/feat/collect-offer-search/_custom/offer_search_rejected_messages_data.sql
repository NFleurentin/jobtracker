-- liquibase formatted sql
-- changeset  SqlCl:1794997337487 stripComments:false logicalFilePath:_custom/offer_search_rejected_messages_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/collect-offer-search/_custom/offer_search_rejected_messages_data.sql:null:null:custom






-- =============================================================================
-- offer_search_rejected_messages_data.sql : message d'une recherche d'offres
-- refusée par l'API France Travail (erreur 400, ft_offer_search.search) ;
-- {1} est le motif donné par l'API, en français
--
-- Donnée de référence, hors de project export (dml désactivé dans le projet).
-- Rejouable : un message présent prend le texte du dépôt (voir
-- app_messages_data.sql).
-- =============================================================================
merge into app_messages m
using (
    values ( 'OFFER_SEARCH_REJECTED', 'fr', 'La recherche est refusée par France Travail : {1}' )
) v ( message_key, language_code, message_text )
on ( m.message_key = v.message_key
     and m.language_code = v.language_code )
when matched then
    update set m.message_text = v.message_text
     where m.message_text <> v.message_text
when not matched then
    insert ( message_key, language_code, message_text )
    values ( v.message_key, v.language_code, v.message_text );

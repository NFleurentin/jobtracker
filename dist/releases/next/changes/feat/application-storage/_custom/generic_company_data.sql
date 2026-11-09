-- liquibase formatted sql
-- changeset  SqlCl:1794243845262 stripComments:false logicalFilePath:_custom/generic_company_data.sql
-- sqlcl_snapshot dist/releases/next/changes/feat/application-storage/_custom/generic_company_data.sql:null:null:custom



-- =============================================================================
-- generic_company_data.sql : entreprise générique et ses messages
--
-- Hors de project export (dml désactivé dans le projet).
-- L'entreprise générique est destinataire des candidatures sans entreprise
-- connue (annonce anonyme). Rejouable : créée si aucune entreprise n'est
-- marquée is_generic ; un nom changé par l'utilisateur est conservé.
-- Message : un message présent prend le texte du dépôt.
-- =============================================================================
insert into companies (
    company_name,
    is_generic
)
select
    'Confidentielle',
    true
from
    dual
where
    not exists (
        select
            null
        from
            companies
        where
            is_generic = true
    );

merge into app_messages m
using (
    values ( 'COMPANY_GENERIC_UNDELETABLE', 'fr', 'L''entreprise générique « {1} » ne peut pas être supprimée : elle sert aux candidatures sans entreprise connue.' )
) v ( message_key, language_code, message_text )
on ( m.message_key = v.message_key
     and m.language_code = v.language_code )
when matched then
    update set m.message_text = v.message_text
     where m.message_text <> v.message_text
when not matched then
    insert ( message_key, language_code, message_text )
    values ( v.message_key, v.language_code, v.message_text );

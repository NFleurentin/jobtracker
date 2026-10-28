-- =============================================================================
-- check_credential.sql : contrôle du Web Credential de l'API France Travail
--   - FRANCE_TRAVAIL_API : OAuth2 client credentials, static id référencé par
--     les packages de collecte
--
-- Le credential se crée à la main dans le Builder (procédure dans le README) :
-- apex_credential refuse le schéma applicatif, qui n'est pas administrateur
-- du workspace (ORA-20987), et SYS, qui n'accorde pas INHERIT PRIVILEGES au
-- schéma d'APEX (ORA-06598, protection voulue, à ne pas lever).
--
-- Ce script ne fait que lire : il renvoie OK, ABSENT ou DIVERGENT (type, scope,
-- envoi des identifiants au jeton ou URL autorisées différents des valeurs
-- attendues ci-dessous, Named Scopes renseignés, ou secret délégué à un
-- credential de la base). Les URL reprennent les deux hôtes de
-- network_acl.sql, sans autre URL.
--
-- Joué par l'administrateur, après create_workspace.sql. Rejouable.
-- =============================================================================
set heading off pagesize 0 feedback off

with expected as (
   select 'FRANCE_TRAVAIL_API'                   as static_id,
          'OAUTH2_CLIENT_CREDENTIALS'            as credential_type_code,
          'api_offresdemploiv2 o2dsoffre'        as scope,
          'BODY'                                 as oauth_token_request_type_code,
          'https://entreprise.francetravail.fr/' as token_url,
          'https://api.francetravail.io/'        as api_url
     from dual
)
select case
          when c.static_id is null then
             'ABSENT'
          when c.credential_type_code = e.credential_type_code
           and c.scope = e.scope
           and c.named_scopes is null
           and c.oauth_token_request_type_code = e.oauth_token_request_type_code
           and c.db_credential_name is null
           -- Séparateurs ignorés : seules les deux URL attendues, dans un ordre quelconque
           and regexp_replace(c.valid_for_urls, '[[:space:],]', null)
                  in (e.token_url || e.api_url, e.api_url || e.token_url)
          then
             'OK'
          else
             'DIVERGENT'
       end as credential_status
  from expected e
  left join apex_workspace_credentials c
    on c.workspace = 'JOBTRACKER'
   and c.static_id = e.static_id;

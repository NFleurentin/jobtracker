-- =============================================================================
-- harden_apex.sql : verrouille les comptes ouverts par les images du dev
--   - APEX_LISTENER, APEX_REST_PUBLIC_USER : mots de passe publics (OraCle#2 et
--     #3, écrits en dur dans l'entrypoint de l'image ORDS), inutilisés : le pool
--     ORDS se connecte en ORDS_PUBLIC_USER.
--   - PDBADMIN : créé par l'image Free avec le mot de passe SYS, inutilisé.
-- APEX_PUBLIC_USER reste ouvert : ORDS s'y connecte par proxy (gateway proxied).
--
-- Dev uniquement (sur ADB, APEX et ORDS sont administrés par Oracle).
-- Joué en SYS dans FREEPDB1. Rejouable.
-- =============================================================================
begin
   <<lock_accounts>>
   for r_user in (
      select username
        from dba_users
       where username in ('APEX_LISTENER', 'APEX_REST_PUBLIC_USER', 'PDBADMIN')
   )
   loop
      execute immediate 'alter user ' || dbms_assert.enquote_name(r_user.username) || ' account lock';
   end loop lock_accounts;
end;
/

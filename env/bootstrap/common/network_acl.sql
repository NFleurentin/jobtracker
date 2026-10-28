-- =============================================================================
-- network_acl.sql : accès réseau sortant vers l'API France Travail
--   - entreprise.francetravail.fr : jeton OAuth2
--   - api.francetravail.io        : API Offres d'emploi
-- HTTPS (port 443) uniquement.
--
-- Bénéficiaire : le schéma d'APEX (APEX_260100 pour APEX 26.1), seul à
-- appeler UTL_HTTP, dans APEX_WEB_SERVICE, en session APEX comme dans un job.
-- JOBTRACKER ne reçoit rien : ses appels HTTP passent par APEX_WEB_SERVICE.
-- Le schéma d'APEX change à chaque version : rejouer après une montée de
-- version d'APEX.
--
-- Joué par l'administrateur, après l'installation d'APEX. Rejouable : une
-- ACE identique à une ACE existante n'est pas ajoutée une seconde fois.
-- =============================================================================
declare
   co_hosts constant sys.odcivarchar2list := sys.odcivarchar2list(
      'entreprise.francetravail.fr',
      'api.francetravail.io'
   );
begin
   <<append_aces>>
   for i in 1 .. co_hosts.count
   loop
      dbms_network_acl_admin.append_host_ace(
         host       => co_hosts(i),
         lower_port => 443,
         upper_port => 443,
         ace        => xs$ace_type(
                          privilege_list => xs$name_list('http'),
                          principal_name => apex_application.g_flow_schema_owner,
                          principal_type => xs_acl.ptype_db
                       )
      );
   end loop append_aces;
end;
/

commit;

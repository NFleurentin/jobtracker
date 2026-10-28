-- liquibase formatted sql
-- changeset jobtracker:1793194915946 stripComments:false  logicalFilePath:feat/collect-staging/jobtracker/comments/collect_requests.sql
-- sqlcl_snapshot src/database/jobtracker/comments/collect_requests.sql:null:0f93f941f00ae90c3e456769b63b75de3070e0db:create

comment on table jobtracker.collect_requests is
    'Staging de la collecte : une ligne par requête HTTP, réponse brute sans transformation. Le découpage en offres se fait à la lecture (JSON_TABLE).'
    ;

comment on column jobtracker.collect_requests.error_message is
    'Erreur sans réponse HTTP exploitable : délai, ACL, certificat.';

comment on column jobtracker.collect_requests.request_url is
    'URL sans paramètres ni identifiants ; les en-têtes de requête ne sont jamais stockés (jeton OAuth2).';

comment on column jobtracker.collect_requests.response_payload_json is
    'Corps de la réponse s''il est du JSON valide ; null sinon (erreur, corps vide), voir response_code et error_message.';


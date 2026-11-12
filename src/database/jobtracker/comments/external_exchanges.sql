comment on table jobtracker.external_exchanges is
    'Journal des échanges avec les systèmes externes, indépendant de tout contexte métier : une ligne par échange, insérée à l''envoi (PENDING) puis complétée à la réception. Écrit en transaction autonome par exchange_log : survit au rollback de l''appelant. Purgé chaque jour selon la rétention de chaque système (external_systems).'
    ;

comment on column jobtracker.external_exchanges.app_user is
    'Utilisateur APEX, ou utilisateur de la base hors session APEX (job, script).';

comment on column jobtracker.external_exchanges.correlation_id is
    'Identifiant commun aux échanges d''une même opération (pages d''une recherche...), fourni par l''appelant via exchange_log.new_correlation_id ; null pour un échange isolé.'
    ;

comment on column jobtracker.external_exchanges.db_sid is
    'SID de la session de base, pour la retrouver dans v$session tant que l''échange est PENDING ; sans serial#, ne suffit pas à la tuer, et n''a plus de sens une fois l''échange clos (session réutilisée par le pool ORDS).'
    ;

comment on column jobtracker.external_exchanges.error_message is
    'Erreur sans réponse exploitable : délai, réseau, ACL, certificat.';

comment on column jobtracker.external_exchanges.request is
    'Enveloppe de la requête, forme fixée par le protocole. HTTP : {"url", "method", "params":[{"name","value"}], "headers":[{"name","value"}], "body"} ; params et headers tels qu''envoyés, valeurs sensibles masquées ; body imbriqué s''il est du JSON, chaîne sinon.'
    ;

comment on column jobtracker.external_exchanges.response is
    'Enveloppe de la réponse, forme fixée par le protocole. HTTP : {"status_code", "headers":[{"name","value"}], "body"} ; body imbriqué s''il est du JSON, chaîne sinon. Null sans réponse.'
    ;


-- sqlcl_snapshot {"hash":"9f3ed463169848111a9740a47bf7a5d3ce2864ad","type":"COMMENT","name":"EXTERNAL_EXCHANGES","schemaName":"jobtracker","sxml":""}
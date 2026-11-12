create or replace package jobtracker.exchange_log authid definer is
    /**
     * Journal des échanges avec les systèmes externes (external_exchanges),
     * indépendant de tout contexte métier : une ligne par échange, ouverte à
     * l'envoi, close à la réception ou en échec. Chaque écriture est validée
     * en transaction autonome : la trace survit au rollback de l'appelant, y
     * compris celui que fait APEX en obtenant un jeton OAuth2. Seconde
     * exception, après http_util.make_rest_request, à la règle des COMMIT.
     * Utilisateur, session APEX, module, action et SID sont lus dans la
     * session à l'ouverture.
     */

    -- Systèmes appelés (external_systems)
    co_system_france_travail constant varchar2(30 char) := 'FRANCE_TRAVAIL';

    -- Protocoles (exchange_protocols)
    co_protocol_http constant varchar2(20 char) := 'HTTP';

    -- États (exchange_statuses)
    co_status_pending constant varchar2(20 char) := 'PENDING';
    co_status_completed constant varchar2(20 char) := 'COMPLETED';
    co_status_failed constant varchar2(20 char) := 'FAILED';

    /**
     * Nouvel identifiant de corrélation, à passer à tous les échanges d'une
     * même opération (pages d'une recherche...).
     * @return 16 octets (SYS_GUID)
     */
    function new_correlation_id return raw;

    /**
     * Ouvre un échange à l'état PENDING, avant l'envoi.
     * @param in_external_system_code   code du système (co_system_)
     * @param in_exchange_protocol_code code du protocole (co_protocol_)
     * @param in_request                enveloppe de la requête, forme fixée par le
     *                                  protocole ; secrets déjà masqués
     * @param in_correlation_id         null pour un échange isolé
     * @return identifiant de l'échange
     * @throws app_errors.e_not_found système ou protocole inconnu
     */
    function open_exchange (
        in_external_system_code   in varchar2,
        in_exchange_protocol_code in varchar2,
        in_request                in json,
        in_correlation_id         in raw default null
    ) return number;

    /**
     * Clôt un échange qui a reçu une réponse, quel que soit son code.
     * @param in_response enveloppe de la réponse, forme fixée par le protocole
     * @throws app_errors.e_not_found     échange inconnu
     * @throws app_errors.e_invalid_state échange déjà clos
     */
    procedure complete_exchange (
        in_external_exchange_id in number,
        in_response             in json
    );

    /**
     * Clôt un échange sans réponse exploitable (délai, réseau...).
     * @param in_error_message erreur, tronquée à 4000 caractères
     * @param in_response      réponse partielle éventuelle, null sinon
     * @throws app_errors.e_not_found     échange inconnu
     * @throws app_errors.e_invalid_state échange déjà clos
     */
    procedure fail_exchange (
        in_external_exchange_id in number,
        in_error_message        in varchar2,
        in_response             in json default null
    );

    /**
     * Passe en FAILED les échanges PENDING plus anciens que le délai de leur
     * système (external_systems.orphan_delay_minutes) : session tuée entre
     * l'envoi et la réponse. Ne valide pas, l'appelant fait le COMMIT.
     */
    procedure abandon_orphans;

    /**
     * Supprime un lot d'échanges plus anciens que la rétention de leur système
     * (external_systems.retention_days), quel que soit leur état. Ne valide
     * pas : l'appelant fait le COMMIT et rappelle tant que le lot est plein.
     * @param in_max_rows taille maximale du lot
     * @param out_deleted nombre d'échanges supprimés ; inférieur à in_max_rows,
     *                    il ne reste rien à supprimer
     */
    procedure delete_expired (
        in_max_rows in pls_integer,
        out_deleted out pls_integer
    );

    /**
     * Point d'entrée du job EXCHANGE_LOG_HOUSEKEEPING : delete_expired par
     * lots, puis abandon_orphans sur les échanges conservés, avec un COMMIT
     * après chaque lot et après abandon_orphans.
     */
    procedure run_housekeeping;

end exchange_log;
/


-- sqlcl_snapshot {"hash":"4e6623dd7748bfb3200cc8ee765be58f9b15bd2d","type":"PACKAGE_SPEC","name":"EXCHANGE_LOG","schemaName":"JOBTRACKER","sxml":""}
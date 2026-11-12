create or replace package jobtracker.test_external_exchange_name_values authid definer is
    -- =========================================================================
    -- Tests de la vue external_exchange_name_values : paires nom/valeur des
    -- enveloppes HTTP (paramètres et en-têtes), ordre et répétitions.
    -- Chaque test écrit directement dans external_exchanges ; utPLSQL annule
    -- ses écritures à la fin (rollback auto).
    -- Suppose les données de référence de external_systems,
    -- exchange_protocols et exchange_statuses.
    -- =========================================================================

    --%suite(external_exchange_name_values)

    --%test(sépare paramètres et en-têtes de la requête, en-têtes de la réponse)
    procedure split_by_envelope_and_type;

    --%test(garde l'ordre d'envoi et les noms répétés)
    procedure keeps_order_and_repeated_names;

    --%test(n'a aucune ligne pour un échange en cours sans réponse)
    procedure pending_without_response_headers;

    --%test(n'a aucune ligne pour un autre protocole)
    procedure other_protocol_without_rows;

end test_external_exchange_name_values;
/

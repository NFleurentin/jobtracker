create or replace package jobtracker.test_external_exchange_details authid definer is
    -- =========================================================================
    -- Tests de la vue external_exchange_details : libellés des référentiels,
    -- champs lus dans les enveloppes selon le protocole et durée.
    -- Chaque test écrit directement dans external_exchanges, sans passer par
    -- exchange_log (transaction autonome, hors du sujet de la vue) ;
    -- utPLSQL annule ses écritures à la fin (rollback auto).
    -- Suppose les données de référence de external_systems,
    -- exchange_protocols et exchange_statuses.
    -- =========================================================================

    --%suite(external_exchange_details)

    --%test(lit la méthode, l'URL et le code de retour d'un échange HTTP)
    procedure http_fields_extracted;

    --%test(n'a ni code de retour ni durée pour un échange en cours)
    procedure pending_without_response;

    --%test(donne la durée en secondes, millisecondes comprises)
    procedure duration_in_seconds;

    --%test(laisse les champs HTTP à null pour un autre protocole)
    procedure other_protocol_without_http_fields;

    --%test(laisse le code de retour à null s'il n'est pas numérique)
    procedure malformed_status_code_is_null;

    --%test(indente un corps JSON)
    procedure json_body_pretty;

    --%test(rend un corps texte tel quel)
    procedure text_body_as_is;

    --%test(n'a pas de corps pour un corps JSON null)
    procedure null_body_is_null;

    --%test(remonte les libellés français)
    procedure labels_in_french;

    --%test(remonte les libellés anglais dans une session APEX en anglais)
    --%beforetest(test_helpers.start_english_session)
    --%aftertest(test_helpers.end_english_session)
    procedure labels_in_english_session;

end test_external_exchange_details;
/

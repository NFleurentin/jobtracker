create or replace package jobtracker.test_exchange_log authid definer is
    -- =========================================================================
    -- Tests de exchange_log. Ses écritures sont validées en transaction
    -- autonome : le rollback automatique d'utPLSQL ne les annule pas, il est
    -- désactivé pour la suite ; les échanges créés sont supprimés après
    -- chaque test (cleanup).
    -- Suppose les données de référence.
    -- =========================================================================

    --%suite(exchange_log)
    --%rollback(manual)

    --%aftereach(cleanup)

    /** Supprime les échanges créés par le test, en transaction autonome. */
    procedure cleanup;

    --%test(charge les systèmes, protocoles et états cités par les constantes)
    procedure reference_codes_loaded;

    --%test(génère des identifiants de corrélation de 16 octets, distincts)
    procedure new_correlation_id_unique;

    --%test(ouvre un échange PENDING avec la requête et le contexte de session)
    procedure open_exchange_pending;

    --%test(garde l'échange ouvert après un rollback de l'appelant)
    procedure open_exchange_survives_rollback;

    --%test(refuse un système inconnu)
    --%throws(-20001)
    procedure open_exchange_unknown_system;

    --%test(refuse un protocole inconnu)
    --%throws(-20001)
    procedure open_exchange_unknown_protocol;

    --%test(clôt un échange COMPLETED avec la réponse et son code)
    procedure complete_exchange_stores_response;

    --%test(clôt un échange FAILED avec l'erreur)
    procedure fail_exchange_stores_error;

    --%test(refuse de clore un échange déjà clos)
    --%throws(-20002)
    procedure close_exchange_twice;

    --%test(refuse de clore un échange inconnu)
    --%throws(-20001)
    procedure close_exchange_unknown;

    -- abandon_orphans et delete_expired ne valident pas : leurs tests
    -- insèrent directement dans la table et reviennent au rollback
    -- automatique d'utPLSQL

    --%test(supprime les échanges plus anciens que la rétention du système)
    --%rollback(auto)
    procedure delete_expired_old;

    --%test(passe en FAILED un PENDING plus ancien que le délai du système)
    --%rollback(auto)
    procedure abandon_orphans_old_pending;

    --%test(laisse PENDING un échange plus récent que le délai du système)
    --%rollback(auto)
    procedure abandon_orphans_keeps_recent;

    --%test(supprime un PENDING plus ancien que la rétention, dans l'ordre de run_housekeeping)
    --%rollback(auto)
    procedure housekeeping_deletes_expired_orphan;

    --%test(supprime par lots, le dernier lot incomplet)
    --%rollback(auto)
    procedure delete_expired_by_batch;

    --%test(refuse une rétention hors de 1 à 7 jours)
    --%rollback(auto)
    --%throws(-2290)
    procedure retention_days_out_of_range;

    --%test(refuse un délai des orphelins hors de 5 à 1440 minutes)
    --%rollback(auto)
    --%throws(-2290)
    procedure orphan_delay_out_of_range;

end test_exchange_log;
/

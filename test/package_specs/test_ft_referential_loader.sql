create or replace package jobtracker.test_ft_referential_loader authid definer is
    -- =========================================================================
    -- Tests de ft_referential_loader.load_response sur des fixtures JSON, sans
    -- appel réseau : run_load et start_load, qui appellent l'API et valident
    -- la transaction, se valident en dev à la main (README). Codes de test
    -- préfixés par T, absents de l'API. utPLSQL annule les écritures.
    -- =========================================================================

    --%suite(ft_referential_loader)

    --%context(MERGE)

    --%test(insère les codes reçus avec le chargement courant)
    procedure codes_inserted;

    --%test(met à jour le libellé et le chargement d'un code existant)
    procedure code_updated;

    --%test(compte les codes du chargement précédent absents de la réponse)
    procedure missing_codes_counted;

    --%test(rend de nouveau courant un code réapparu)
    procedure reappeared_code_current;

    --%test(charge les pays, continents et types de contrat)
    procedure independent_referentials_loaded;

    --%endcontext

    --%context(rattachements)

    --%test(rattache un département à sa région)
    procedure department_region_set;

    --%test(charge sans région et signale un département rattaché à une région inconnue)
    procedure department_unknown_region;

    --%test(charge sans département et signale une commune rattachée à un département inconnu)
    procedure commune_unknown_department;

    --%endcontext

    --%context(réponse refusée)

    --%test(refuse un tableau vide)
    --%throws(app_errors.co_invalid_response)
    procedure empty_array_rejected;

    --%test(refuse une réponse nulle)
    --%throws(app_errors.co_invalid_response)
    procedure null_response_rejected;

    --%test(refuse un JSON invalide)
    --%throws(app_errors.co_invalid_response)
    procedure invalid_json_rejected;

    --%test(refuse un objet JSON au lieu d'un tableau)
    --%throws(app_errors.co_invalid_response)
    procedure object_response_rejected;

    --%test(laisse les codes intacts sur une réponse refusée)
    procedure rejected_response_keeps_codes;

    --%test(refuse un référentiel inconnu)
    --%throws(app_errors.co_not_found)
    procedure unknown_referential_rejected;

    --%endcontext
end test_ft_referential_loader;
/

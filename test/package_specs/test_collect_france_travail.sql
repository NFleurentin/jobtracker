create or replace package jobtracker.test_collect_france_travail authid definer is
    -- =========================================================================
    -- Tests des fonctions pures de collect_france_travail, sans appel réseau.
    -- Cas de pagination repris de jobboard (tap-francetravail, test_paginator.py).
    -- =========================================================================

    --%suite(collect_france_travail)

    --%context(parse_total)

    --%test(lit le total après le "/")
    procedure parse_total_reads_total;

    --%test(renvoie null sans total après le "/")
    procedure parse_total_without_total;

    --%test(renvoie null sur un en-tête absent)
    procedure parse_total_without_header;

    --%endcontext

    --%context(has_more)

    --%test(206 au début : il reste des pages)
    procedure has_more_partial_content;

    --%test(200 : tout le résultat tient dans la page)
    procedure has_more_complete_content;

    --%test(204 : aucun résultat)
    procedure has_more_no_content;

    --%test(206 à 750 : page suivante 900-1049, sous le plafond)
    procedure has_more_below_cap;

    --%test(206 à 2850 : page suivante 3000-3149, la dernière autorisée)
    procedure has_more_before_last_allowed_page;

    --%test(206 à 3000 : 3000-3149 est la dernière page autorisée)
    procedure has_more_at_cap;

    --%test(206 sur la page qui contient le dernier résultat)
    procedure has_more_last_result_in_page;

    --%test(total multiple de 150 : 1800-1949 est la dernière page)
    procedure has_more_total_multiple_of_page;

    --%test(un résultat reste sur la page 1950-2099)
    procedure has_more_one_result_left;

    --%endcontext

    --%context(check_page)

    --%test(accepte une recherche sous le plafond)
    procedure check_page_within_cap;

    --%test(accepte une 200 sans total)
    procedure check_page_complete_without_total;

    --%test(refuse une recherche au-dessus du plafond)
    --%throws(app_errors.co_limit_exceeded)
    procedure check_page_above_cap;

    --%test(refuse une 206 sans total)
    --%throws(app_errors.co_invalid_response)
    procedure check_page_without_total;

    --%endcontext
end test_collect_france_travail;
/

create or replace package jobtracker.test_job_details authid definer is
    -- =========================================================================
    -- Tests de la vue job_details : nombre de postes de contacts par poste.
    -- Chaque test écrit réellement dans jobs ; utPLSQL annule ses écritures
    -- à la fin (rollback auto).
    -- =========================================================================

    --%suite(job_details)

    --%test(garde un poste sans contact, avec zéro poste occupé)
    procedure job_without_position;

    --%test(compte les postes occupés par le poste, et seulement les siens)
    procedure position_count;

end test_job_details;
/

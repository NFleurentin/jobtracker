create or replace package jobtracker.test_ft_enumerations authid definer is
    -- =========================================================================
    -- Tests des énumérations de la recherche France Travail, listes fixes
    -- chargées par migration (_custom/ft_enumerations_data.sql) : chaque
    -- table porte exactement les codes attendus par l'API.
    -- =========================================================================

    --%suite(ft_enumerations)

    --%test(charge les codes de ft_experiences)
    procedure experiences_loaded;

    --%test(charge les codes de ft_experience_requirements)
    procedure experience_requirements_loaded;

    --%test(charge les codes de ft_salary_periods)
    procedure salary_periods_loaded;

    --%test(charge les codes de ft_offer_origins)
    procedure offer_origins_loaded;

end test_ft_enumerations;
/

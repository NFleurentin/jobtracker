create or replace package body jobtracker.test_ft_enumerations is

    /** Compare les codes lus par le curseur à la liste attendue. */
    procedure expect_codes (
        io_actual in out sys_refcursor,
        in_codes  in sys.odcivarchar2list
    ) is
        l_expected sys_refcursor;
    begin
        open l_expected for select
            column_value as code
        from
            table ( in_codes )
        order by
            column_value;

        ut.expect(io_actual).to_equal(l_expected);
    end expect_codes;

    procedure experiences_loaded is
        l_actual sys_refcursor;
    begin
        open l_actual for select
            experience_code as code
        from
            ft_experiences
        order by
            experience_code;

        expect_codes(l_actual,
                     sys.odcivarchar2list('1', '2', '3'));
    end experiences_loaded;

    procedure experience_requirements_loaded is
        l_actual sys_refcursor;
    begin
        open l_actual for select
            experience_requirement_code as code
        from
            ft_experience_requirements
        order by
            experience_requirement_code;

        expect_codes(l_actual,
                     sys.odcivarchar2list('D', 'E', 'S'));
    end experience_requirements_loaded;

    procedure salary_periods_loaded is
        l_actual sys_refcursor;
    begin
        open l_actual for select
            salary_period_code as code
        from
            ft_salary_periods
        order by
            salary_period_code;

        expect_codes(l_actual,
                     sys.odcivarchar2list('A', 'C', 'H', 'M'));
    end salary_periods_loaded;

    procedure offer_origins_loaded is
        l_actual sys_refcursor;
    begin
        open l_actual for select
            offer_origin_code as code
        from
            ft_offer_origins
        order by
            offer_origin_code;

        expect_codes(l_actual,
                     sys.odcivarchar2list('1', '2'));
    end offer_origins_loaded;

end test_ft_enumerations;
/

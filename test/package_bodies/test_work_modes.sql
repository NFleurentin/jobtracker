create or replace package body jobtracker.test_work_modes is

    /** Insère un mode de travail. */
    procedure insert_mode (
        in_code    in work_modes.work_mode_code%type,
        in_name_fr in work_modes.work_mode_name_fr%type,
        in_name_en in work_modes.work_mode_name_en%type
    ) is
    begin
        insert into work_modes (
            work_mode_code,
            work_mode_name_fr,
            work_mode_name_en
        ) values
            ( in_code,
              in_name_fr,
              in_name_en );

    end insert_mode;

    /**
     * Vérifie que l'insertion viole la clé unique donnée, et pas une autre.
     * @param in_constraint nom de la contrainte attendue, en majuscules
     */
    procedure expect_unique_violation (
        in_code       in work_modes.work_mode_code%type,
        in_name_fr    in work_modes.work_mode_name_fr%type,
        in_name_en    in work_modes.work_mode_name_en%type,
        in_constraint in varchar2
    ) is
    begin
        insert_mode(in_code, in_name_fr, in_name_en);
        ut.fail('Doublon accepté');
    exception
        when dup_val_on_index then
            ut.expect(sqlerrm).to_be_like('%'
                                          || in_constraint || '%');
    end expect_unique_violation;

    procedure reference_codes_loaded is
        l_actual   sys_refcursor;
        l_expected sys_refcursor;
    begin
        open l_actual for select
            work_mode_code
        from
            work_modes
        order by
            work_mode_code;

        open l_expected for select
            column_value as work_mode_code
        from
            table ( sys.odcivarchar2list('FULL_REMOTE', 'HYBRID', 'ON_SITE') )
        order by
            column_value;

        ut.expect(l_actual).to_equal(l_expected);
    end reference_codes_loaded;

    procedure code_unique is
    begin
        expect_unique_violation('HYBRID', 'Mode de test', 'Test mode', 'WORK_MODES_WORK_MODE_CODE_UK');
    end code_unique;

    procedure name_fr_unique is
    begin
        expect_unique_violation('TEST_MODE', 'Hybride', 'Test mode', 'WORK_MODES_WORK_MODE_NAME_FR_UK');
    end name_fr_unique;

    procedure name_en_unique is
    begin
        expect_unique_violation('TEST_MODE', 'Mode de test', 'Hybrid', 'WORK_MODES_WORK_MODE_NAME_EN_UK');
    end name_en_unique;

    procedure code_required is
    begin
        insert_mode(null, 'Mode de test', 'Test mode');
    end code_required;

    procedure name_fr_required is
    begin
        insert_mode('TEST_MODE', null, 'Test mode');
    end name_fr_required;

    procedure name_en_required is
    begin
        insert_mode('TEST_MODE', 'Mode de test', null);
    end name_en_required;

end test_work_modes;
/

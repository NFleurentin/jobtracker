create or replace package body jobtracker.test_application_types is

    /** Insère un type de candidature. */
    procedure insert_type (
        in_code    in application_types.application_type_code%type,
        in_name_fr in application_types.application_type_name_fr%type,
        in_name_en in application_types.application_type_name_en%type
    ) is
    begin
        insert into application_types (
            application_type_code,
            application_type_name_fr,
            application_type_name_en
        ) values
            ( in_code,
              in_name_fr,
              in_name_en );

    end insert_type;

    /**
     * Vérifie que l'insertion viole la clé unique donnée, et pas une autre.
     * @param in_constraint nom de la contrainte attendue, en majuscules
     */
    procedure expect_unique_violation (
        in_code       in application_types.application_type_code%type,
        in_name_fr    in application_types.application_type_name_fr%type,
        in_name_en    in application_types.application_type_name_en%type,
        in_constraint in varchar2
    ) is
    begin
        insert_type(in_code, in_name_fr, in_name_en);
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
            application_type_code
        from
            application_types
        order by
            application_type_code;

        open l_expected for select
            column_value as application_type_code
        from
            table ( sys.odcivarchar2list('APPROACHED', 'JOB_OFFER', 'SPONTANEOUS') )
        order by
            column_value;

        ut.expect(l_actual).to_equal(l_expected);
    end reference_codes_loaded;

    procedure code_unique is
    begin
        expect_unique_violation('SPONTANEOUS', 'Type de test', 'Test type', 'APPLICATION_TYPES_APPLICATION_TYPE_CODE_UK');
    end code_unique;

    procedure name_fr_unique is
    begin
        expect_unique_violation('TEST_TYPE', 'Candidature spontanée', 'Test type', 'APPLICATION_TYPES_APPLICATION_TYPE_NAME_FR_UK');
    end name_fr_unique;

    procedure name_en_unique is
    begin
        expect_unique_violation('TEST_TYPE', 'Type de test', 'Unsolicited application', 'APPLICATION_TYPES_APPLICATION_TYPE_NAME_EN_UK'
        );
    end name_en_unique;

    procedure code_required is
    begin
        insert_type(null, 'Type de test', 'Test type');
    end code_required;

    procedure name_fr_required is
    begin
        insert_type('TEST_TYPE', null, 'Test type');
    end name_fr_required;

    procedure name_en_required is
    begin
        insert_type('TEST_TYPE', 'Type de test', null);
    end name_en_required;

end test_application_types;
/

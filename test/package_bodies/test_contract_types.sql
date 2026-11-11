create or replace package body jobtracker.test_contract_types is

    /** Insère un type de contrat. */
    procedure insert_type (
        in_code    in contract_types.contract_type_code%type,
        in_name_fr in contract_types.contract_type_name_fr%type,
        in_name_en in contract_types.contract_type_name_en%type
    ) is
    begin
        insert into contract_types (
            contract_type_code,
            contract_type_name_fr,
            contract_type_name_en
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
        in_code       in contract_types.contract_type_code%type,
        in_name_fr    in contract_types.contract_type_name_fr%type,
        in_name_en    in contract_types.contract_type_name_en%type,
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
            contract_type_code
        from
            contract_types
        order by
            contract_type_code;

        open l_expected for select
            column_value as contract_type_code
        from
            table ( sys.odcivarchar2list('FIXED_TERM', 'FREELANCE', 'INTERNSHIP', 'PERMANENT', 'TEMPORARY',
                                         'WORK_STUDY') )
        order by
            column_value;

        ut.expect(l_actual).to_equal(l_expected);
    end reference_codes_loaded;

    procedure code_unique is
    begin
        expect_unique_violation('PERMANENT', 'Type de test', 'Test type', 'CONTRACT_TYPES_CONTRACT_TYPE_CODE_UK');
    end code_unique;

    procedure name_fr_unique is
    begin
        expect_unique_violation('TEST_TYPE', 'CDI', 'Test type', 'CONTRACT_TYPES_CONTRACT_TYPE_NAME_FR_UK');
    end name_fr_unique;

    procedure name_en_unique is
    begin
        expect_unique_violation('TEST_TYPE', 'Type de test', 'Permanent', 'CONTRACT_TYPES_CONTRACT_TYPE_NAME_EN_UK');
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

end test_contract_types;
/

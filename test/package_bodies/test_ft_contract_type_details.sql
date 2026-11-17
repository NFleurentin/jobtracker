create or replace package body jobtracker.test_ft_contract_type_details is

    /** Ouvre un chargement et rend son identifiant. */
    function new_load return ft_referential_loads.ft_referential_load_id%type is
        l_load_id ft_referential_loads.ft_referential_load_id%type;
    begin
        insert into ft_referential_loads ( started_at ) values
            ( systimestamp )
        returning ft_referential_load_id into l_load_id;

        return l_load_id;
    end new_load;

    /** Pose le chargement donné sur un code, en le créant au besoin. */
    procedure load_code (
        in_code    in ft_contract_types.contract_type_code%type,
        in_load_id in ft_contract_types.ft_referential_load_id%type
    ) is
    begin
        merge into ft_contract_types t
        using (
            select
                in_code as code
            from
                dual
        ) s on ( t.contract_type_code = s.code )
        when matched then update
        set t.ft_referential_load_id = in_load_id
        when not matched then
        insert (
            contract_type_code,
            contract_type_name,
            ft_referential_load_id )
        values
            ( s.code,
              'Libellé de test',
              in_load_id );

    end load_code;

    /** Indicateur courant du code dans la vue. */
    function is_current (
        in_code in ft_contract_types.contract_type_code%type
    ) return boolean is
        l_is_current boolean;
    begin
        select
            is_current
        into l_is_current
        from
            ft_contract_type_details
        where
            contract_type_code = in_code;

        return l_is_current;
    end is_current;

    procedure latest_load_current is
    begin
        load_code('TEST1', new_load);
        ut.expect(is_current('TEST1')).to_be_true;
    end latest_load_current;

    procedure missing_code_not_current is
        l_load_id ft_referential_loads.ft_referential_load_id%type;
    begin
        load_code('TEST1', new_load);
        l_load_id := new_load;
        load_code('TEST2', l_load_id);
        ut.expect(is_current('TEST1')).to_be_false;
        ut.expect(is_current('TEST2')).to_be_true;
    end missing_code_not_current;

    procedure untouched_load_keeps_current is
        l_load_id ft_referential_loads.ft_referential_load_id%type;
    begin
        l_load_id := new_load;
        load_code('TEST1', l_load_id);
        load_code('TEST2', l_load_id);
        -- Chargement suivant en échec pour ce référentiel : aucun code reçu
        l_load_id := new_load;
        ut.expect(is_current('TEST1')).to_be_true;
        ut.expect(is_current('TEST2')).to_be_true;
    end untouched_load_keeps_current;

    procedure reappeared_code_current is
        l_load_id ft_referential_loads.ft_referential_load_id%type;
    begin
        load_code('TEST1', new_load);
        load_code('TEST2', new_load);
        l_load_id := new_load;
        load_code('TEST1', l_load_id);
        load_code('TEST2', l_load_id);
        ut.expect(is_current('TEST1')).to_be_true;
    end reappeared_code_current;

end test_ft_contract_type_details;
/

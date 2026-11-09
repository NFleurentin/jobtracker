create or replace package body jobtracker.test_application_statuses is

    /** Insère un statut de candidature. */
    procedure insert_status (
        in_code          in application_statuses.application_status_code%type,
        in_name_fr       in application_statuses.application_status_name_fr%type,
        in_name_en       in application_statuses.application_status_name_en%type,
        in_display_order in application_statuses.display_order%type,
        in_funnel_step   in application_statuses.funnel_step%type,
        in_is_final      in application_statuses.is_final%type
    ) is
    begin
        insert into application_statuses (
            application_status_code,
            application_status_name_fr,
            application_status_name_en,
            display_order,
            funnel_step,
            is_final
        ) values
            ( in_code,
              in_name_fr,
              in_name_en,
              in_display_order,
              in_funnel_step,
              in_is_final );

    end insert_status;

    /**
     * Vérifie que l'insertion viole la clé unique donnée, et pas une autre.
     * @param in_constraint nom de la contrainte attendue, en majuscules
     */
    procedure expect_unique_violation (
        in_code          in application_statuses.application_status_code%type,
        in_name_fr       in application_statuses.application_status_name_fr%type,
        in_name_en       in application_statuses.application_status_name_en%type,
        in_display_order in application_statuses.display_order%type,
        in_funnel_step   in application_statuses.funnel_step%type,
        in_constraint    in varchar2
    ) is
    begin
        insert_status(in_code, in_name_fr, in_name_en, in_display_order, in_funnel_step,
                      false);
        ut.fail('Doublon accepté');
    exception
        when dup_val_on_index then
            ut.expect(sqlerrm).to_be_like('%'
                                          || in_constraint || '%');
    end expect_unique_violation;

    procedure reference_statuses_loaded is
        l_actual   sys_refcursor;
        l_expected sys_refcursor;
    begin
        -- is_final converti en Y/N : comparaison de curseurs sans dépendre du
        -- support du type BOOLEAN SQL par utPLSQL
        open l_actual for select
            application_status_code,
            funnel_step,
            case
                when is_final then
                    'Y'
                else
                    'N'
            end as is_final
        from
            application_statuses
        order by
            display_order;

        open l_expected for select
            *
        from
            ( values
                ( 'TO_APPLY',
                  1,
                  'N' ),
                ( 'APPLIED',
                  2,
                  'N' ),
                ( 'INTERVIEWING',
                  3,
                  'N' ),
                ( 'OFFER_RECEIVED',
                  4,
                  'N' ),
                ( 'ACCEPTED',
                  5,
                  'Y' ),
                ( 'REJECTED',
                  null,
                  'Y' ),
                ( 'WITHDRAWN',
                  null,
                  'Y' ),
                ( 'NO_RESPONSE',
                  null,
                  'Y' )
            ) v ( application_status_code,
                  funnel_step,
                  is_final );

        ut.expect(l_actual).to_equal(l_expected);
    end reference_statuses_loaded;

    procedure code_unique is
    begin
        expect_unique_violation('APPLIED', 'Statut de test', 'Test status', 999, null,
                                'APPLICATION_STATUSES_APPLICATION_STATUS_CODE_UK');
    end code_unique;

    procedure name_fr_unique is
    begin
        expect_unique_violation('TEST_STATUS', 'Acceptée', 'Test status', 999, null,
                                'APPLICATION_STATUSES_APPLICATION_STATUS_NAME_FR_UK');
    end name_fr_unique;

    procedure name_en_unique is
    begin
        expect_unique_violation('TEST_STATUS', 'Statut de test', 'Accepted', 999, null,
                                'APPLICATION_STATUSES_APPLICATION_STATUS_NAME_EN_UK');
    end name_en_unique;

    procedure display_order_unique is
    begin
        expect_unique_violation('TEST_STATUS', 'Statut de test', 'Test status', 10, null,
                                'APPLICATION_STATUSES_DISPLAY_ORDER_UK');
    end display_order_unique;

    procedure funnel_step_unique is
    begin
        expect_unique_violation('TEST_STATUS', 'Statut de test', 'Test status', 999, 1,
                                'APPLICATION_STATUSES_FUNNEL_STEP_UK');
    end funnel_step_unique;

    procedure funnel_step_null_repeatable is
    begin
        -- les données de départ ont déjà des statuts hors funnel
        insert_status('TEST_STATUS', 'Statut de test', 'Test status', 999, null,
                      true);
    end funnel_step_null_repeatable;

    procedure funnel_step_positive is
    begin
        insert_status('TEST_STATUS', 'Statut de test', 'Test status', 999, 0,
                      false);
    end funnel_step_positive;

    procedure code_required is
    begin
        insert_status(null, 'Statut de test', 'Test status', 999, null,
                      false);
    end code_required;

    procedure name_fr_required is
    begin
        insert_status('TEST_STATUS', null, 'Test status', 999, null,
                      false);
    end name_fr_required;

    procedure name_en_required is
    begin
        insert_status('TEST_STATUS', 'Statut de test', null, 999, null,
                      false);
    end name_en_required;

    procedure display_order_required is
    begin
        insert_status('TEST_STATUS', 'Statut de test', 'Test status', null, null,
                      false);
    end display_order_required;

    procedure is_final_required is
    begin
        insert_status('TEST_STATUS', 'Statut de test', 'Test status', 999, null,
                      null);
    end is_final_required;

end test_application_statuses;
/

create or replace package body jobtracker.test_external_system_api is

    co_unknown_system_id constant external_systems.external_system_id%type := -1;

    /** Identifiant du système France Travail, présent dans les données de référence. */
    function france_travail_id return external_systems.external_system_id%type is
        l_external_system_id external_systems.external_system_id%type;
    begin
        select
            external_system_id
        into l_external_system_id
        from
            external_systems
        where
            external_system_code = exchange_log.co_system_france_travail;

        return l_external_system_id;
    end france_travail_id;

    procedure update_replaces_settings is
        l_external_system_id external_systems.external_system_id%type := france_travail_id;
        r_system             external_systems%rowtype;
    begin
        external_system_api.update_external_system(l_external_system_id, 3, 30, false);
        select
            *
        into r_system
        from
            external_systems
        where
            external_system_id = l_external_system_id;

        ut.expect(r_system.retention_days).to_equal(3);
        ut.expect(r_system.orphan_delay_minutes).to_equal(30);
        ut.expect(r_system.is_exchange_logged).to_be_false();
    end update_replaces_settings;

    procedure update_unknown is
    begin
        external_system_api.update_external_system(co_unknown_system_id, 3, 30, true);
    end update_unknown;

    procedure update_retention_out_of_range is
    begin
        external_system_api.update_external_system(france_travail_id, 8, 30, true);
    end update_retention_out_of_range;

    procedure update_orphan_delay_out_of_range is
    begin
        external_system_api.update_external_system(france_travail_id, 3, 4, true);
    end update_orphan_delay_out_of_range;

end test_external_system_api;
/

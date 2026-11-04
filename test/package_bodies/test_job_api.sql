create or replace package body jobtracker.test_job_api is

    co_unknown_job_id constant jobs.job_id%type := -1;

    /** Ligne du poste donné. */
    function get_job (
        in_job_id in jobs.job_id%type
    ) return jobs%rowtype is
        r_job jobs%rowtype;
    begin
        select
            *
        into r_job
        from
            jobs
        where
            job_id = in_job_id;

        return r_job;
    end get_job;

    /** Crée le poste de test de référence. */
    function create_test_job return jobs.job_id%type is
    begin
        return job_api.create_job('Test scout', 'Éclaireur de test');
    end create_test_job;

    procedure create_job_both_names is
        r_job jobs%rowtype;
    begin
        r_job := get_job(create_test_job);
        ut.expect(r_job.job_name_en).to_equal('Test scout');
        ut.expect(r_job.job_name_fr).to_equal('Éclaireur de test');
    end create_job_both_names;

    procedure create_job_duplicate_en is
        l_job_id jobs.job_id%type;
    begin
        l_job_id := create_test_job;
        l_job_id := job_api.create_job('TEST SCOUT', 'Autre éclaireur');
    end create_job_duplicate_en;

    procedure create_job_duplicate_fr is
        l_job_id jobs.job_id%type;
    begin
        l_job_id := create_test_job;
        l_job_id := job_api.create_job('Other scout', 'éclaireur DE TEST');
    end create_job_duplicate_fr;

    procedure create_job_duplicate_message is
        l_job_id jobs.job_id%type;
    begin
        l_job_id := create_test_job;
        l_job_id := job_api.create_job('Other scout', 'éclaireur DE TEST');
        ut.fail('Doublon accepté');
    exception
        when app_errors.e_duplicate_value then
            ut.expect(sqlerrm).to_be_like('%« éclaireur DE TEST »%');
    end create_job_duplicate_message;

    procedure create_job_names_required is
        l_job_id jobs.job_id%type;
    begin
        l_job_id := job_api.create_job('Test scout', null);
    end create_job_names_required;

    procedure update_job_replaces_names is
        l_job_id jobs.job_id%type;
        r_job    jobs%rowtype;
    begin
        l_job_id := create_test_job;
        job_api.update_job(l_job_id, 'Test pathfinder', 'Pisteur de test');
        r_job := get_job(l_job_id);
        ut.expect(r_job.job_name_en).to_equal('Test pathfinder');
        ut.expect(r_job.job_name_fr).to_equal('Pisteur de test');
    end update_job_replaces_names;

    procedure update_job_own_name_case is
        l_job_id jobs.job_id%type;
    begin
        l_job_id := create_test_job;
        job_api.update_job(l_job_id, 'TEST SCOUT', 'Éclaireur de test');
        ut.expect(get_job(l_job_id).job_name_en).to_equal('TEST SCOUT');
    end update_job_own_name_case;

    procedure update_job_duplicate is
        l_job_id jobs.job_id%type;
    begin
        l_job_id := create_test_job;
        l_job_id := job_api.create_job('Other scout', 'Autre éclaireur');
        job_api.update_job(l_job_id, 'test scout', 'Autre éclaireur');
    end update_job_duplicate;

    procedure update_job_unknown is
    begin
        job_api.update_job(co_unknown_job_id, 'Test scout', 'Éclaireur de test');
    end update_job_unknown;

    procedure delete_job_removes_row is
        l_job_id jobs.job_id%type;
        l_count  pls_integer;
    begin
        l_job_id := create_test_job;
        job_api.delete_job(l_job_id);
        select
            count(*)
        into l_count
        from
            jobs
        where
            job_id = l_job_id;

        ut.expect(l_count).to_equal(0);
    end delete_job_removes_row;

    procedure delete_job_unknown is
    begin
        job_api.delete_job(co_unknown_job_id);
    end delete_job_unknown;

    procedure delete_job_in_use is
        l_job_id              jobs.job_id%type;
        l_contact_position_id contact_positions.contact_position_id%type;
    begin
        l_job_id := create_test_job;
        l_contact_position_id := contact_api.create_position(
            in_contact_id => contact_api.create_contact('Martin'),
            in_company_id => company_api.create_company('Test'),
            in_job_id     => l_job_id,
            in_is_current => true
        );

        job_api.delete_job(l_job_id);
        ut.fail('Suppression acceptée');
    exception
        when app_errors.e_row_referenced then
            ut.expect(sqlerrm).to_be_like('%« Éclaireur de test »%');
    end delete_job_in_use;

end test_job_api;
/

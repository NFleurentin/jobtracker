create or replace package body jobtracker.test_ft_referential_loads is

    /** Insère un chargement. */
    procedure insert_load (
        in_started_at  in ft_referential_loads.started_at%type,
        in_ended_at    in ft_referential_loads.ended_at%type,
        in_load_status in ft_referential_loads.load_status%type
    ) is
    begin
        insert into ft_referential_loads (
            started_at,
            ended_at,
            load_status
        ) values
            ( in_started_at,
              in_ended_at,
              in_load_status );

    end insert_load;

    procedure running_load_accepted is
        l_started_at ft_referential_loads.started_at%type;
    begin
        insert into ft_referential_loads ( load_details ) values
            ( null )
        returning started_at into l_started_at;

        ut.expect(l_started_at).to_be_not_null;
    end running_load_accepted;

    procedure statuses_accepted is
        l_count pls_integer;
    begin
        insert_load(systimestamp, systimestamp, 'SUCCESS');
        insert_load(systimestamp, systimestamp, 'PARTIAL');
        insert_load(systimestamp, systimestamp, 'ERROR');
        select
            count(*)
        into l_count
        from
            ft_referential_loads
        where
                started_at >= systimestamp - interval '1' minute
            and load_status is not null;

        ut.expect(l_count).to_be_greater_or_equal(3);
    end statuses_accepted;

    procedure unknown_status_rejected is
    begin
        insert_load(systimestamp, systimestamp, 'RUNNING');
    end unknown_status_rejected;

    procedure end_without_status_rejected is
    begin
        insert_load(systimestamp, systimestamp, null);
    end end_without_status_rejected;

    procedure status_without_end_rejected is
    begin
        insert_load(systimestamp, null, 'SUCCESS');
    end status_without_end_rejected;

    procedure end_before_start_rejected is
    begin
        insert_load(systimestamp, systimestamp - interval '1' hour, 'SUCCESS');
    end end_before_start_rejected;

end test_ft_referential_loads;
/

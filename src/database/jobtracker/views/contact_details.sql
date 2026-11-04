create or replace force editionable view jobtracker.contact_details (
    contact_id,
    first_name,
    last_name,
    salutation_id,
    salutation_short_name,
    salutation_long_name,
    email,
    phone,
    linkedin_slug,
    note_text,
    position_count,
    created_at,
    updated_at
) as
    select
        c.contact_id,
        c.first_name,
        c.last_name,
        c.salutation_id,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                s.salutation_short_name_en
            else
                s.salutation_short_name_fr
        end as salutation_short_name,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                s.salutation_long_name_en
            else
                s.salutation_long_name_fr
        end as salutation_long_name,
        c.email,
        c.phone,
        c.linkedin_slug,
        c.note_text,
        (
            select
                count(*)
            from
                jobtracker.contact_positions cp
            where
                cp.contact_id = c.contact_id
        )   as position_count,
        c.created_at,
        c.updated_at
    from
        jobtracker.contacts    c
        left join jobtracker.salutations s on s.salutation_id = c.salutation_id
with read only;


-- sqlcl_snapshot {"hash":"7473bd5a65dfe772a9f90ae02b499ff492689b4f","type":"VIEW","name":"CONTACT_DETAILS","schemaName":"JOBTRACKER","sxml":""}
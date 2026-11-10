create or replace force editionable view jobtracker.application_details (
    application_id,
    company_id,
    company_name,
    is_generic_company,
    application_type_id,
    application_type_code,
    application_type_name,
    job_title,
    annual_salary_proposed_euros,
    daily_rate_proposed_euros,
    interest_rating,
    note_text,
    application_status_id,
    application_status_code,
    application_status_name,
    application_status_display_order,
    is_final,
    funnel_step,
    status_changed_at,
    created_at,
    updated_at
) as
    select
        a.application_id,
        a.company_id,
        co.company_name,
        co.is_generic   as is_generic_company,
        a.application_type_id,
        t.application_type_code,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                t.application_type_name_en
            else
                t.application_type_name_fr
        end             as application_type_name,
        a.job_title,
        a.annual_salary_proposed_euros,
        a.daily_rate_proposed_euros,
        a.interest_rating,
        a.note_text,
        cs.application_status_id,
        s.application_status_code,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                s.application_status_name_en
            else
                s.application_status_name_fr
        end             as application_status_name,
        s.display_order as application_status_display_order,
        s.is_final,
        s.funnel_step,
        cs.changed_at   as status_changed_at,
        a.created_at,
        a.updated_at
    from
             jobtracker.applications a
        join jobtracker.companies            co on co.company_id = a.company_id
        join jobtracker.application_types    t on t.application_type_id = a.application_type_id
        -- Statut courant : le changement le plus récent, l'identifiant
        -- départageant les égalités de changed_at
        outer apply (
            select
                sc.application_status_id,
                sc.changed_at
            from
                jobtracker.application_status_changes sc
            where
                sc.application_id = a.application_id
            order by
                sc.changed_at desc,
                sc.application_status_change_id desc
            fetch first 1 row only
        )                               cs
        left join jobtracker.application_statuses s on s.application_status_id = cs.application_status_id
with read only;


-- sqlcl_snapshot {"hash":"fc33f21e9526b404f45ca7400e2ae2d28e113a70","type":"VIEW","name":"APPLICATION_DETAILS","schemaName":"JOBTRACKER","sxml":""}
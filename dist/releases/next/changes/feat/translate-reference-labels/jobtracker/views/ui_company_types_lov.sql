-- liquibase formatted sql
-- changeset JOBTRACKER:1793723863056 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/views/ui_company_types_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_company_types_lov.sql:b9a3d932bdb4b86b764c18888cfad054dacbb367:3165a50a2c8f64366e5bf77be24b5eaf809081e0:alter

create or replace force editionable view jobtracker.ui_company_types_lov (
    return_value,
    display_value
) as
    select
        company_type_id as return_value,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                company_type_name_en
            else
                company_type_name
        end             as display_value
    from
        jobtracker.company_types
with read only;


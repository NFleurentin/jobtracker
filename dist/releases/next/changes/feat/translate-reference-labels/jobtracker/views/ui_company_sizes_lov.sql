-- liquibase formatted sql
-- changeset JOBTRACKER:1793723863062 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/views/ui_company_sizes_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_company_sizes_lov.sql:45c1de3477b66fda704f5c40d0389d2335cfadd4:1a71e84a028c0f707797458bf7295112713b7b9b:alter

create or replace force editionable view jobtracker.ui_company_sizes_lov (
    return_value,
    display_value,
    display_order
) as
    select
        company_size_id as return_value,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                company_size_long_name_en
            else
                company_size_long_name
        end             as display_value,
        display_order
    from
        jobtracker.company_sizes
with read only;


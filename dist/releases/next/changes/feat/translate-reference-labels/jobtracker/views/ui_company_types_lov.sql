-- liquibase formatted sql
-- changeset JOBTRACKER:1793724733500 stripComments:false  logicalFilePath:feat/translate-reference-labels/jobtracker/views/ui_company_types_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_company_types_lov.sql:b9a3d932bdb4b86b764c18888cfad054dacbb367:3858b431e8da229bd619b8ce0764179416efea93:alter

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
                company_type_name_fr
        end             as display_value
    from
        jobtracker.company_types
with read only;


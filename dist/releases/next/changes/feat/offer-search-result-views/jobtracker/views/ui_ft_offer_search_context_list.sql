-- liquibase formatted sql
-- changeset JOBTRACKER:1795008487125 stripComments:false  logicalFilePath:feat/offer-search-result-views/jobtracker/views/ui_ft_offer_search_context_list.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_ft_offer_search_context_list.sql:null:f35344b740c989c6f8c8c7245dde8437be59fb59:create

create or replace force editionable view jobtracker.ui_ft_offer_search_context_list (
    external_id,
    item_type,
    item_position,
    item_name,
    item_description
) as
    select
        external_id,
        item_type,
        item_position,
        item_name,
        item_description
    from
        jobtracker.ft_offer_search_result_items
    where
        item_type in ( 'WORKING_HOURS', 'WORKING_CONDITION', 'OFFICE_TOOL', 'SALARY_COMPLEMENT', 'PROFESSIONAL_QUALITY' )
with read only;


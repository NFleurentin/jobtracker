-- liquibase formatted sql
-- changeset JOBTRACKER:1795008487113 stripComments:false  logicalFilePath:feat/offer-search-result-views/jobtracker/views/ui_ft_offer_search_partners_list.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_ft_offer_search_partners_list.sql:null:1d7fd41a9a415919e25f8757e5168b1e55b453d5:create

create or replace force editionable view jobtracker.ui_ft_offer_search_partners_list (
    external_id,
    item_position,
    partner_name,
    offer_url,
    logo_url
) as
    select
        external_id,
        item_position,
        item_name     as partner_name,
        item_url      as offer_url,
        item_logo_url as logo_url
    from
        jobtracker.ft_offer_search_result_items
    where
        item_type = 'PARTNER'
with read only;


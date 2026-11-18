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


-- sqlcl_snapshot {"hash":"1d7fd41a9a415919e25f8757e5168b1e55b453d5","type":"VIEW","name":"UI_FT_OFFER_SEARCH_PARTNERS_LIST","schemaName":"JOBTRACKER","sxml":""}
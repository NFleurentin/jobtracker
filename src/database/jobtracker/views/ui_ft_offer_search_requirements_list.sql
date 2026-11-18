create or replace force editionable view jobtracker.ui_ft_offer_search_requirements_list (
    external_id,
    item_type,
    item_position,
    item_name,
    requirement_name
) as
    select
        external_id,
        -- LANGUAGE ou DRIVING_LICENCE
        item_type,
        item_position,
        item_name,
        -- Exigence selon la documentation de l'API, le code s'il est inconnu
        case requirement_code
            when 'E' then
                'Exigé'
            when 'S' then
                'Souhaité'
            else
                requirement_code
        end as requirement_name
    from
        jobtracker.ft_offer_search_result_items
    where
        item_type in ( 'LANGUAGE', 'DRIVING_LICENCE' )
with read only;


-- sqlcl_snapshot {"hash":"84ded057c748a478147e6041dc3d34e16bdc9cc9","type":"VIEW","name":"UI_FT_OFFER_SEARCH_REQUIREMENTS_LIST","schemaName":"JOBTRACKER","sxml":""}
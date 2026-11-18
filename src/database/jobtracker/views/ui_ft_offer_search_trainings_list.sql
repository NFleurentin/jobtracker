create or replace force editionable view jobtracker.ui_ft_offer_search_trainings_list (
    external_id,
    item_position,
    training_code,
    training_field_name,
    training_level_name,
    training_comment,
    requirement_name
) as
    select
        external_id,
        item_position,
        item_code        as training_code,
        item_name        as training_field_name,
        item_level       as training_level_name,
        item_description as training_comment,
        -- Exigence selon la documentation de l'API, le code s'il est inconnu
        case requirement_code
            when 'E' then
                'Exigé'
            when 'S' then
                'Souhaité'
            else
                requirement_code
        end              as requirement_name
    from
        jobtracker.ft_offer_search_result_items
    where
        item_type = 'TRAINING'
with read only;


-- sqlcl_snapshot {"hash":"a72c79fb1f8227186d40c1c06ad9ebe7278b469c","type":"VIEW","name":"UI_FT_OFFER_SEARCH_TRAININGS_LIST","schemaName":"JOBTRACKER","sxml":""}
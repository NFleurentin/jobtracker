create or replace force editionable view jobtracker.ui_ft_offer_search_skills_list (
    external_id,
    item_position,
    skill_code,
    skill_name,
    requirement_name
) as
    select
        external_id,
        item_position,
        item_code as skill_code,
        item_name as skill_name,
        -- Exigence selon la documentation de l'API, le code s'il est inconnu
        case requirement_code
            when 'E' then
                'Exigé'
            when 'S' then
                'Souhaité'
            else
                requirement_code
        end       as requirement_name
    from
        jobtracker.ft_offer_search_result_items
    where
        item_type = 'SKILL'
with read only;


-- sqlcl_snapshot {"hash":"fdca10a76347033730c583195384a143777bf794","type":"VIEW","name":"UI_FT_OFFER_SEARCH_SKILLS_LIST","schemaName":"JOBTRACKER","sxml":""}
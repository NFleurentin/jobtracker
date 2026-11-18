create or replace force editionable view jobtracker.ft_offer_search_result_items (
    external_id,
    item_type,
    item_position,
    item_code,
    item_name,
    item_level,
    item_description,
    requirement_code,
    item_url,
    item_logo_url
) as
    with offers as (
        select
            c.c001 as external_id,
            c.clob001
        from
            apex_collections c
        where
            c.collection_name = 'FT_OFFER_SEARCH'
    )
    select
        o.external_id,
        'SKILL' as item_type,
        j.item_position,
        j.item_code,
        j.item_name,
        null    as item_level,
        null    as item_description,
        j.requirement_code,
        null    as item_url,
        null    as item_logo_url
    from
        offers o,
        json_table ( o.clob001, '$.competences[*]'
                columns (
                    item_position for ordinality,
                    item_code varchar2 ( 4000 char ) truncate path '$.code',
                    item_name varchar2 ( 4000 char ) truncate path '$.libelle',
                    requirement_code varchar2 ( 4000 char ) truncate path '$.exigence'
                )
            )
        j
    union all
    select
        o.external_id,
        'TRAINING' as item_type,
        j.item_position,
        j.item_code,
        j.item_name,
        j.item_level,
        j.item_description,
        j.requirement_code,
        null       as item_url,
        null       as item_logo_url
    from
        offers o,
        json_table ( o.clob001, '$.formations[*]'
                columns (
                    item_position for ordinality,
                    item_code varchar2 ( 4000 char ) truncate path '$.codeFormation',
                    item_name varchar2 ( 4000 char ) truncate path '$.domaineLibelle',
                    item_level varchar2 ( 4000 char ) truncate path '$.niveauLibelle',
                    item_description varchar2 ( 4000 char ) truncate path '$.commentaire',
                    requirement_code varchar2 ( 4000 char ) truncate path '$.exigence'
                )
            )
        j
    union all
    select
        o.external_id,
        'LANGUAGE' as item_type,
        j.item_position,
        null       as item_code,
        j.item_name,
        null       as item_level,
        null       as item_description,
        j.requirement_code,
        null       as item_url,
        null       as item_logo_url
    from
        offers o,
        json_table ( o.clob001, '$.langues[*]'
                columns (
                    item_position for ordinality,
                    item_name varchar2 ( 4000 char ) truncate path '$.libelle',
                    requirement_code varchar2 ( 4000 char ) truncate path '$.exigence'
                )
            )
        j
    union all
    select
        o.external_id,
        'DRIVING_LICENCE' as item_type,
        j.item_position,
        null              as item_code,
        j.item_name,
        null              as item_level,
        null              as item_description,
        j.requirement_code,
        null              as item_url,
        null              as item_logo_url
    from
        offers o,
        json_table ( o.clob001, '$.permis[*]'
                columns (
                    item_position for ordinality,
                    item_name varchar2 ( 4000 char ) truncate path '$.libelle',
                    requirement_code varchar2 ( 4000 char ) truncate path '$.exigence'
                )
            )
        j
    union all
    select
        o.external_id,
        'OFFICE_TOOL' as item_type,
        j.item_position,
        null          as item_code,
        j.item_name,
        null          as item_level,
        null          as item_description,
        null          as requirement_code,
        null          as item_url,
        null          as item_logo_url
    from
        offers o,
        json_table ( o.clob001, '$.outilsBureautiques[*]'
                columns (
                    item_position for ordinality,
                    item_name varchar2 ( 4000 char ) truncate path '$'
                )
            )
        j
    union all
    select
        o.external_id,
        'SALARY_COMPLEMENT' as item_type,
        j.item_position,
        j.item_code,
        j.item_name,
        null                as item_level,
        null                as item_description,
        null                as requirement_code,
        null                as item_url,
        null                as item_logo_url
    from
        offers o,
        json_table ( o.clob001, '$.salaire.listeComplements[*]'
                columns (
                    item_position for ordinality,
                    item_code varchar2 ( 4000 char ) truncate path '$.code',
                    item_name varchar2 ( 4000 char ) truncate path '$.libelle'
                )
            )
        j
    union all
    select
        o.external_id,
        'PROFESSIONAL_QUALITY' as item_type,
        j.item_position,
        null                   as item_code,
        j.item_name,
        null                   as item_level,
        j.item_description,
        null                   as requirement_code,
        null                   as item_url,
        null                   as item_logo_url
    from
        offers o,
        json_table ( o.clob001, '$.qualitesProfessionnelles[*]'
                columns (
                    item_position for ordinality,
                    item_name varchar2 ( 4000 char ) truncate path '$.libelle',
                    item_description varchar2 ( 4000 char ) truncate path '$.description'
                )
            )
        j
    union all
    select
        o.external_id,
        'PARTNER' as item_type,
        j.item_position,
        null      as item_code,
        j.item_name,
        null      as item_level,
        null      as item_description,
        null      as requirement_code,
        j.item_url,
        j.item_logo_url
    from
        offers o,
        json_table ( o.clob001, '$.origineOffre.partenaires[*]'
                columns (
                    item_position for ordinality,
                    item_name varchar2 ( 4000 char ) truncate path '$.nom',
                    item_url varchar2 ( 4000 char ) truncate path '$.url',
                    item_logo_url varchar2 ( 4000 char ) truncate path '$.logo'
                )
            )
        j
    union all
    select
        o.external_id,
        'WORKING_HOURS' as item_type,
        j.item_position,
        null            as item_code,
        j.item_name,
        null            as item_level,
        null            as item_description,
        null            as requirement_code,
        null            as item_url,
        null            as item_logo_url
    from
        offers o,
        json_table ( o.clob001, '$.contexteTravail.horaires[*]'
                columns (
                    item_position for ordinality,
                    item_name varchar2 ( 4000 char ) truncate path '$'
                )
            )
        j
    union all
    select
        o.external_id,
        'WORKING_CONDITION' as item_type,
        j.item_position,
        null                as item_code,
        j.item_name,
        null                as item_level,
        null                as item_description,
        null                as requirement_code,
        null                as item_url,
        null                as item_logo_url
    from
        offers o,
        json_table ( o.clob001, '$.contexteTravail.conditionsExercice[*]'
                columns (
                    item_position for ordinality,
                    item_name varchar2 ( 4000 char ) truncate path '$'
                )
            )
        j
with read only;


-- sqlcl_snapshot {"hash":"e806de4f59144e0bd809d0b12f5408ba4ea66bb6","type":"VIEW","name":"FT_OFFER_SEARCH_RESULT_ITEMS","schemaName":"JOBTRACKER","sxml":""}
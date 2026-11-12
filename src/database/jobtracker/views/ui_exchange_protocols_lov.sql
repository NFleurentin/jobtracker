create or replace force editionable view jobtracker.ui_exchange_protocols_lov (
    return_value,
    display_value
) as
    select
        exchange_protocol_id as return_value,
        case (
            select
                jobtracker.app_message.current_language
            from
                dual
        )
            when 'en' then
                exchange_protocol_name_en
            else
                exchange_protocol_name_fr
        end                  as display_value
    from
        jobtracker.exchange_protocols
with read only;


-- sqlcl_snapshot {"hash":"6bdaca4e0d114b273fcfa7f282c61f551687da7d","type":"VIEW","name":"UI_EXCHANGE_PROTOCOLS_LOV","schemaName":"JOBTRACKER","sxml":""}
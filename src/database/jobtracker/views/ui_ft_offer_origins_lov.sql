create or replace force editionable view jobtracker.ui_ft_offer_origins_lov (
    return_value,
    display_value
) as
    select
        offer_origin_code as return_value,
        offer_origin_name as display_value
    from
        jobtracker.ft_offer_origins
with read only;


-- sqlcl_snapshot {"hash":"521c01b7f2546f446cb5fa94bdbb0d8117679d14","type":"VIEW","name":"UI_FT_OFFER_ORIGINS_LOV","schemaName":"JOBTRACKER","sxml":""}
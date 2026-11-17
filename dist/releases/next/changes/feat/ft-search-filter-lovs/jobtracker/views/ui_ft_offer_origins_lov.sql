-- liquibase formatted sql
-- changeset JOBTRACKER:1794948023946 stripComments:false  logicalFilePath:feat/ft-search-filter-lovs/jobtracker/views/ui_ft_offer_origins_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_ft_offer_origins_lov.sql:null:521c01b7f2546f446cb5fa94bdbb0d8117679d14:create

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


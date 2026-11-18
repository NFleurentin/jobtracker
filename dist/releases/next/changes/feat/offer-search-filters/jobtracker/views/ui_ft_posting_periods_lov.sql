-- liquibase formatted sql
-- changeset JOBTRACKER:1794994602479 stripComments:false  logicalFilePath:feat/offer-search-filters/jobtracker/views/ui_ft_posting_periods_lov.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_ft_posting_periods_lov.sql:null:76cf905a95b2a4a0b949f6ecde69730791dbec51:create

create or replace force editionable view jobtracker.ui_ft_posting_periods_lov (
    return_value,
    display_value,
    display_order
) as
    select
        posting_period_code            as return_value,
        posting_period_name            as display_value,
        to_number(posting_period_code) as display_order
    from
        jobtracker.ft_posting_periods
with read only;


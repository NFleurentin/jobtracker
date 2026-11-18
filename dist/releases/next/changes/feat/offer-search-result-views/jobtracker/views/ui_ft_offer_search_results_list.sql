-- liquibase formatted sql
-- changeset JOBTRACKER:1795008487201 stripComments:false  logicalFilePath:feat/offer-search-result-views/jobtracker/views/ui_ft_offer_search_results_list.sql
-- sqlcl_snapshot src/database/jobtracker/views/ui_ft_offer_search_results_list.sql:null:445b2b1b7c140fba739550a5453e8642effb41e4:create

create or replace force editionable view jobtracker.ui_ft_offer_search_results_list (
    search_rank,
    external_id,
    title,
    updated_at,
    workplace_name,
    company_name,
    contract_type_name
) as
    select
        -- Tri par défaut du rapport : ordre de l'API
        search_rank,
        external_id,
        title,
        cast(updated_at as timestamp with local time zone) as updated_at,
        -- Libellés, le code quand le libellé manque
        coalesce(workplace_name, workplace_commune_code)   as workplace_name,
        company_name,
        coalesce(contract_type_name, contract_type_code)   as contract_type_name
    from
        jobtracker.ft_offer_search_results
with read only;


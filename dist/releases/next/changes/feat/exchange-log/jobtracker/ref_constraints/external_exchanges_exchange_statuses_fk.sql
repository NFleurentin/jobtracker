-- liquibase formatted sql
-- changeset JOBTRACKER:1794482562766 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/ref_constraints/external_exchanges_exchange_statuses_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/external_exchanges_exchange_statuses_fk.sql:null:a7c5097ba0d366af1e4051a59132720d71737a32:create

alter table jobtracker.external_exchanges
    add constraint external_exchanges_exchange_statuses_fk
        foreign key ( exchange_status_id )
            references jobtracker.exchange_statuses ( exchange_status_id )
        enable;


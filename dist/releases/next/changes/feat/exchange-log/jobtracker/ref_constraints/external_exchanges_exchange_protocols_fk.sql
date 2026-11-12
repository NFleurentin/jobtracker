-- liquibase formatted sql
-- changeset JOBTRACKER:1794482562790 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/ref_constraints/external_exchanges_exchange_protocols_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/external_exchanges_exchange_protocols_fk.sql:null:010addfa323cfc8fe6536b27ed0a381ed7bb2cdc:create

alter table jobtracker.external_exchanges
    add constraint external_exchanges_exchange_protocols_fk
        foreign key ( exchange_protocol_id )
            references jobtracker.exchange_protocols ( exchange_protocol_id )
        enable;


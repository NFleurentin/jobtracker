-- liquibase formatted sql
-- changeset JOBTRACKER:1794482562769 stripComments:false  logicalFilePath:feat/exchange-log/jobtracker/ref_constraints/external_exchanges_external_systems_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/external_exchanges_external_systems_fk.sql:null:f7ac9a08496a9c7c7e0685d47752b9ceb546c9c5:create

alter table jobtracker.external_exchanges
    add constraint external_exchanges_external_systems_fk
        foreign key ( external_system_id )
            references jobtracker.external_systems ( external_system_id )
        enable;


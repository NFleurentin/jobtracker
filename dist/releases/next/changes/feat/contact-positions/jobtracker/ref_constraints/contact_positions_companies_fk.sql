-- liquibase formatted sql
-- changeset JOBTRACKER:1793796994139 stripComments:false  logicalFilePath:feat/contact-positions/jobtracker/ref_constraints/contact_positions_companies_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/contact_positions_companies_fk.sql:null:a9aa72b91c2e3552126be7bd608ea11c67077706:create

alter table jobtracker.contact_positions
    add constraint contact_positions_companies_fk
        foreign key ( company_id )
            references jobtracker.companies ( company_id )
        enable;


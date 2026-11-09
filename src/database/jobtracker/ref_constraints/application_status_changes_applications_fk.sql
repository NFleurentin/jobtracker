alter table jobtracker.application_status_changes
    add constraint application_status_changes_applications_fk
        foreign key ( application_id )
            references jobtracker.applications ( application_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"6de34ae67657b66e6ec3b51fa38239aec1b5fba2","type":"REF_CONSTRAINT","name":"APPLICATION_STATUS_CHANGES_APPLICATIONS_FK","schemaName":"JOBTRACKER","sxml":""}
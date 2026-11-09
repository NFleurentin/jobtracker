alter table jobtracker.application_status_changes
    add constraint application_status_changes_application_statuses_fk
        foreign key ( application_status_id )
            references jobtracker.application_statuses ( application_status_id )
        enable;


-- sqlcl_snapshot {"hash":"25aad0bfcb252e899900d50a0c02f5ace735cfb5","type":"REF_CONSTRAINT","name":"APPLICATION_STATUS_CHANGES_APPLICATION_STATUSES_FK","schemaName":"JOBTRACKER","sxml":""}
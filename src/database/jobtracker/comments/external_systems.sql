comment on table jobtracker.external_systems is
    'Systèmes externes appelés (API...), cités par le journal des échanges. Liste fixe chargée par migration ; le code est la clé stable des packages (constantes de exchange_log).'
    ;

comment on column jobtracker.external_systems.orphan_delay_minutes is
    'Délai en minutes au-delà duquel un échange PENDING du système est réputé abandonné (session tuée) et passé en FAILED par le job EXCHANGE_LOG_HOUSEKEEPING (exchange_log.abandon_orphans) ; à garder au-dessus du délai maximal des appels HTTP.'
    ;

comment on column jobtracker.external_systems.retention_days is
    'Durée de conservation des échanges du système, en jours (7 au plus : données personnelles) ; suppression quotidienne par le job EXCHANGE_LOG_HOUSEKEEPING (exchange_log.delete_expired).'
    ;


-- sqlcl_snapshot {"hash":"945acc3514ad663111588be010a950a40f733930","type":"COMMENT","name":"EXTERNAL_SYSTEMS","schemaName":"jobtracker","sxml":""}
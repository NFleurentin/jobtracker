comment on table jobtracker.collect_runs is
    'Exécutions de la collecte : une ligne par run et par source, y compris les runs en échec avant toute requête.';

comment on column jobtracker.collect_runs.received_offer_count is
    'Nombre d''offres reçues : entrée du garde-fou de volume.';

comment on column jobtracker.collect_runs.status is
    'RUNNING, SUCCEEDED, FAILED (erreur technique), REJECTED (refusé par le garde-fou de volume).';


-- sqlcl_snapshot {"hash":"6b2ceed843af16cf8ed9148b7d249faa8f197c57","type":"COMMENT","name":"COLLECT_RUNS","schemaName":"jobtracker","sxml":""}
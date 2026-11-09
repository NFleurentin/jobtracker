-- liquibase formatted sql
-- changeset jobtracker:1794246055920 stripComments:false  logicalFilePath:feat/application-storage/jobtracker/comments/applications.sql
-- sqlcl_snapshot src/database/jobtracker/comments/applications.sql:null:622c69303ae17591a46c27878d07bf2bda7cfcd6:create

comment on table jobtracker.applications is
    'Candidatures : une par démarche auprès d''une entreprise destinataire (l''ESN ou le cabinet, sinon l''employeur ; l''entreprise générique pour une annonce anonyme). Pas de statut stocké : le statut courant est le changement le plus récent de application_status_changes, exposé par une vue. Écritures par application_api, qui met à jour updated_at et refuse une deuxième candidature ouverte pour une même entreprise.'
    ;


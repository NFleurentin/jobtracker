-- liquibase formatted sql
-- changeset jobtracker:1793716941376 stripComments:false  logicalFilePath:feat/db-message-catalog/jobtracker/comments/app_messages.sql
-- sqlcl_snapshot src/database/jobtracker/comments/app_messages.sql:null:b318d0945686621515e31c6f4214e4c1edc23da0:create

comment on table jobtracker.app_messages is
    'Catalogue des messages de la base affichés à l''utilisateur, un texte par clé et par langue. Lu par le package app_message, repli sur le français.'
    ;

comment on column jobtracker.app_messages.language_code is
    'Langue, code ISO 639-1 en minuscules (fr, en).';

comment on column jobtracker.app_messages.message_key is
    'Clé du message : nom de la contrainte pour une violation de contrainte, sinon <ENTITE>_<NATURE> en majuscules.';

comment on column jobtracker.app_messages.message_text is
    'Texte du message. Paramètres {1} à {3}, placés librement selon la langue. Limité par raise_application_error (2048 octets après substitution).'
    ;


-- liquibase formatted sql
-- changeset jobtracker:1793739868839 stripComments:false  logicalFilePath:feat/contacts-read-views/jobtracker/comments/contact_details.sql
-- sqlcl_snapshot src/database/jobtracker/comments/contact_details.sql:null:653bd625fb6b98b06f6a547ea3688c6a605915cc:create

comment on table jobtracker.contact_details is
    'Contacts avec les libellés de leur civilité.';


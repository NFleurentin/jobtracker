-- liquibase formatted sql
-- changeset jobtracker:1793798337150 stripComments:false  logicalFilePath:feat/contact-positions-views/jobtracker/comments/contact_details.sql
-- sqlcl_snapshot src/database/jobtracker/comments/contact_details.sql:653bd625fb6b98b06f6a547ea3688c6a605915cc:495ce104db9dc773fc2eee9f6bd9631dc79a2f8b:alter

comment on table jobtracker.contact_details is
    'Contacts avec les libellés de leur civilité et le nombre de leurs postes.';


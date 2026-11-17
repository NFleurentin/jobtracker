-- liquibase formatted sql
-- changeset JOBTRACKER:1794922337841 stripComments:false  logicalFilePath:feat/ft-search-filter-tables/jobtracker/ref_constraints/ft_communes_ft_departments_fk.sql
-- sqlcl_snapshot src/database/jobtracker/ref_constraints/ft_communes_ft_departments_fk.sql:null:358ae72c133fee48f8789d4aee061569f6683035:create

alter table jobtracker.ft_communes
    add constraint ft_communes_ft_departments_fk
        foreign key ( department_code )
            references jobtracker.ft_departments ( department_code )
        enable;


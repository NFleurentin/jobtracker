-- liquibase formatted sql
-- changeset JOBTRACKER:1793795578257 stripComments:false  logicalFilePath:feat/job-lookup/jobtracker/package_bodies/job_api.sql
-- sqlcl_snapshot src/database/jobtracker/package_bodies/job_api.sql:null:b07de4502df1276a1b8fec42c335f80c9cc66d39:create

create or replace package body jobtracker.job_api is

    /**
     * Lève l'erreur métier d'un libellé en double, après un ORA-00001.
     * Retrouve le libellé en conflit pour le nommer dans le message : anglais
     * d'abord, les deux index uniques pouvant être violés à la fois.
     * @param in_job_id poste modifié, exclu de la recherche ; null à la création
     * @throws app_errors.co_duplicate_value toujours
     */
    procedure raise_duplicate (
        in_job_id      in jobs.job_id%type,
        in_job_name_en in jobs.job_name_en%type,
        in_job_name_fr in jobs.job_name_fr%type
    ) is
        l_en_count pls_integer;
    begin
        select
            count(*)
        into l_en_count
        from
            jobs
        where
                upper(job_name_en) = upper(in_job_name_en)
            and job_id <> nvl(in_job_id, -1);

        app_message.raise_error(app_errors.co_duplicate_value, 'JOB_DUPLICATE',
                                case
                                    when l_en_count > 0 then
                                        in_job_name_en
                                    else
                                        in_job_name_fr
                                end
        );

    end raise_duplicate;

    function create_job (
        in_job_name_en in jobs.job_name_en%type,
        in_job_name_fr in jobs.job_name_fr%type
    ) return jobs.job_id%type is
        l_job_id jobs.job_id%type;
    begin
        insert into jobs (
            job_name_en,
            job_name_fr
        ) values
            ( in_job_name_en,
              in_job_name_fr )
        returning job_id into l_job_id;

        return l_job_id;
    exception
        when dup_val_on_index then
            raise_duplicate(null, in_job_name_en, in_job_name_fr);
    end create_job;

    procedure update_job (
        in_job_id      in jobs.job_id%type,
        in_job_name_en in jobs.job_name_en%type,
        in_job_name_fr in jobs.job_name_fr%type
    ) is
    begin
        update jobs
        set
            job_name_en = in_job_name_en,
            job_name_fr = in_job_name_fr
        where
            job_id = in_job_id;

        if sql%rowcount = 0 then
            raise_application_error(app_errors.co_not_found, 'Unknown job: ' || in_job_id);
        end if;

    exception
        when dup_val_on_index then
            raise_duplicate(in_job_id, in_job_name_en, in_job_name_fr);
    end update_job;

    procedure delete_job (
        in_job_id in jobs.job_id%type
    ) is
    begin
        delete from jobs
        where
            job_id = in_job_id;

        if sql%rowcount = 0 then
            raise_application_error(app_errors.co_not_found, 'Unknown job: ' || in_job_id);
        end if;

    end delete_job;

end job_api;
/


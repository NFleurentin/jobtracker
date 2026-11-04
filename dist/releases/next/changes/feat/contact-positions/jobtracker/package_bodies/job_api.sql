-- liquibase formatted sql
-- changeset JOBTRACKER:1793796994237 stripComments:false  logicalFilePath:feat/contact-positions/jobtracker/package_bodies/job_api.sql
-- sqlcl_snapshot src/database/jobtracker/package_bodies/job_api.sql:b07de4502df1276a1b8fec42c335f80c9cc66d39:005c3b6f24d268b25e66cfb3b253314daa3d2d52:alter

create or replace package body jobtracker.job_api is

    -- ORA-02292 : suppression d'une ligne parente d'une clé étrangère
    e_child_record_found exception;
    pragma exception_init ( e_child_record_found, -2292 );

    /**
     * Libellé d'un poste dans la langue de la session, français pour toute
     * autre langue, pour un message d'erreur métier.
     */
    function name_of (
        in_job_id in jobs.job_id%type
    ) return jobs.job_name_fr%type is
        l_job_name jobs.job_name_fr%type;
    begin
        select
            case app_message.current_language
                when 'en' then
                    job_name_en
                else
                    job_name_fr
            end
        into l_job_name
        from
            jobs
        where
            job_id = in_job_id;

        return l_job_name;
    end name_of;

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

    exception
        when e_child_record_found then
            app_message.raise_error(app_errors.co_row_referenced,
                                    'JOB_ROW_REFERENCED',
                                    name_of(in_job_id));
    end delete_job;

end job_api;
/


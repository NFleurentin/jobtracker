create or replace package body jobtracker.contact_api is

    function create_contact (
        in_last_name     in contacts.last_name%type,
        in_first_name    in contacts.first_name%type default null,
        in_salutation_id in contacts.salutation_id%type default null,
        in_email         in contacts.email%type default null,
        in_phone         in contacts.phone%type default null,
        in_linkedin_slug in contacts.linkedin_slug%type default null,
        in_note_text     in contacts.note_text%type default null
    ) return contacts.contact_id%type is
        l_contact_id contacts.contact_id%type;
    begin
        insert into contacts (
            last_name,
            first_name,
            salutation_id,
            email,
            phone,
            linkedin_slug,
            note_text
        ) values
            ( in_last_name,
              in_first_name,
              in_salutation_id,
              in_email,
              in_phone,
              in_linkedin_slug,
              in_note_text )
        returning contact_id into l_contact_id;

        return l_contact_id;
    end create_contact;

    procedure update_contact (
        in_contact_id    in contacts.contact_id%type,
        in_last_name     in contacts.last_name%type,
        in_first_name    in contacts.first_name%type,
        in_salutation_id in contacts.salutation_id%type,
        in_email         in contacts.email%type,
        in_phone         in contacts.phone%type,
        in_linkedin_slug in contacts.linkedin_slug%type,
        in_note_text     in contacts.note_text%type
    ) is
    begin
        update contacts
        set
            last_name = in_last_name,
            first_name = in_first_name,
            salutation_id = in_salutation_id,
            email = in_email,
            phone = in_phone,
            linkedin_slug = in_linkedin_slug,
            note_text = in_note_text,
            updated_at = systimestamp
        where
            contact_id = in_contact_id;

        if sql%rowcount = 0 then
            raise_application_error(app_errors.co_not_found, 'Unknown contact: ' || in_contact_id);
        end if;

    end update_contact;

    procedure delete_contact (
        in_contact_id in contacts.contact_id%type
    ) is
    begin
        delete from contacts
        where
            contact_id = in_contact_id;

        if sql%rowcount = 0 then
            raise_application_error(app_errors.co_not_found, 'Unknown contact: ' || in_contact_id);
        end if;

    end delete_contact;

end contact_api;
/


-- sqlcl_snapshot {"hash":"07dea1c00b423935552e16f716d2134c6e24c0b7","type":"PACKAGE_BODY","name":"CONTACT_API","schemaName":"JOBTRACKER","sxml":""}
create or replace package body jobtracker.test_ft_offer_search_results is

    -- Offre fictive avec tous les champs scalaires de l'API
    co_full_offer constant varchar2(4000 char) := q'[{
        "id": "TEST001",
        "intitule": "Data engineer (H/F)",
        "description": "Description fictive",
        "dateCreation": "2026-11-17T08:15:42.000Z",
        "dateActualisation": "2026-11-18T09:30:00Z",
        "lieuTravail": {"libelle": "74 - ANNECY", "latitude": 45.901584,
                        "longitude": 6.125296, "codePostal": "74000",
                        "commune": "74010"},
        "romeCode": "M1811",
        "romeLibelle": "Data engineer",
        "appellationlibelle": "Ingenieur data",
        "entreprise": {"nom": "Entreprise fictive", "description": "Description entreprise",
                       "logo": "https://test.invalid/logo.png",
                       "url": "https://test.invalid", "entrepriseAdaptee": false},
        "typeContrat": "CDD",
        "typeContratLibelle": "CDD - 6 Mois",
        "natureContrat": "Contrat travail",
        "experienceExige": "S",
        "experienceLibelle": "2 ans",
        "experienceCommentaire": "Experience SQL",
        "salaire": {"libelle": "Mensuel de 3000.00 Euros sur 12 mois",
                    "commentaire": "Selon experience",
                    "complement1": "Tickets restaurant", "complement2": "Mutuelle"},
        "dureeTravailLibelle": "35H",
        "dureeTravailLibelleConverti": "Temps plein",
        "complementExercice": "Complement fictif",
        "conditionExercice": "Condition fictive",
        "alternance": true,
        "contact": {"nom": "Contact fictif", "coordonnees1": "Adresse 1",
                    "coordonnees2": "Adresse 2", "coordonnees3": "Adresse 3",
                    "telephone": "0600000000",
                    "courriel": "Pour postuler : https://test.invalid/offre",
                    "commentaire": "Commentaire contact",
                    "urlRecruteur": "https://test.invalid/recruteur",
                    "urlPostulation": "https://test.invalid/postuler"},
        "agence": {"telephone": "0100000000",
                   "courriel": "Pour postuler : https://test.invalid/agence"},
        "nombrePostes": 3,
        "accessibleTH": true,
        "deplacementCode": "1",
        "deplacementLibelle": "Jamais",
        "qualificationCode": "9",
        "qualificationLibelle": "Cadre",
        "codeNAF": "62.02A",
        "secteurActivite": "62",
        "secteurActiviteLibelle": "Conseil en systemes informatiques",
        "trancheEffectifEtab": "50 a 99 salaries",
        "origineOffre": {"origine": "2", "urlOrigine": "https://test.invalid/origine"},
        "offresManqueCandidats": false,
        "entrepriseAdaptee": true,
        "employeurHandiEngage": true
    }]';

    /**
     * Vide la collection de recherche puis y charge des offres.
     * @param in_offers offres JSON, séparées par des virgules
     */
    procedure load (
        in_offers in varchar2
    ) is
        l_count pls_integer;
    begin
        apex_collection.create_or_truncate_collection(ft_offer_search.co_collection_name);
        l_count := ft_offer_search.load_offers('{"resultats": ['
                                               || in_offers || ']}');
    end load;

    procedure all_fields_mapped is
        r_offer ft_offer_search_results%rowtype;
    begin
        load(co_full_offer);
        select
            *
        into r_offer
        from
            ft_offer_search_results;

        ut.expect(r_offer.external_id).to_equal('TEST001');
        ut.expect(r_offer.title).to_equal('Data engineer (H/F)');
        ut.expect(r_offer.description).to_equal(to_clob('Description fictive'));
        ut.expect(r_offer.created_at).to_equal(to_timestamp_tz('2026-11-17 08:15:42 +00:00',
           'YYYY-MM-DD HH24:MI:SS TZH:TZM'));

        ut.expect(r_offer.updated_at).to_equal(to_timestamp_tz('2026-11-18 09:30:00 +00:00',
           'YYYY-MM-DD HH24:MI:SS TZH:TZM'));

        ut.expect(r_offer.workplace_name).to_equal('74 - ANNECY');
        ut.expect(r_offer.workplace_latitude).to_equal(45.901584);
        ut.expect(r_offer.workplace_longitude).to_equal(6.125296);
        ut.expect(r_offer.workplace_postal_code).to_equal('74000');
        ut.expect(r_offer.workplace_commune_code).to_equal('74010');
        ut.expect(r_offer.rome_code).to_equal('M1811');
        ut.expect(r_offer.rome_name).to_equal('Data engineer');
        ut.expect(r_offer.rome_job_title_name).to_equal('Ingenieur data');
        ut.expect(r_offer.company_name).to_equal('Entreprise fictive');
        ut.expect(r_offer.company_description).to_equal(to_clob('Description entreprise'));
        ut.expect(r_offer.company_logo_url).to_equal('https://test.invalid/logo.png');
        ut.expect(r_offer.company_url).to_equal('https://test.invalid');
        ut.expect(r_offer.is_adapted_company).to_be_false;
        ut.expect(r_offer.contract_type_code).to_equal('CDD');
        ut.expect(r_offer.contract_type_name).to_equal('CDD - 6 Mois');
        ut.expect(r_offer.contract_nature_name).to_equal('Contrat travail');
        ut.expect(r_offer.experience_requirement_code).to_equal('S');
        ut.expect(r_offer.experience_name).to_equal('2 ans');
        ut.expect(r_offer.experience_comment).to_equal('Experience SQL');
        ut.expect(r_offer.salary_name).to_equal('Mensuel de 3000.00 Euros sur 12 mois');
        ut.expect(r_offer.salary_comment).to_equal('Selon experience');
        ut.expect(r_offer.salary_complement_1).to_equal('Tickets restaurant');
        ut.expect(r_offer.salary_complement_2).to_equal('Mutuelle');
        ut.expect(r_offer.working_hours_name).to_equal('35H');
        ut.expect(r_offer.working_time_name).to_equal('Temps plein');
        ut.expect(r_offer.exercise_complement).to_equal('Complement fictif');
        ut.expect(r_offer.exercise_condition).to_equal('Condition fictive');
        ut.expect(r_offer.is_work_study).to_be_true;
        ut.expect(r_offer.contact_name).to_equal('Contact fictif');
        ut.expect(r_offer.contact_address_1).to_equal('Adresse 1');
        ut.expect(r_offer.contact_address_2).to_equal('Adresse 2');
        ut.expect(r_offer.contact_address_3).to_equal('Adresse 3');
        ut.expect(r_offer.contact_phone).to_equal('0600000000');
        ut.expect(r_offer.contact_email).to_equal('Pour postuler : https://test.invalid/offre');
        ut.expect(r_offer.contact_comment).to_equal('Commentaire contact');
        ut.expect(r_offer.recruiter_url).to_equal('https://test.invalid/recruteur');
        ut.expect(r_offer.application_url).to_equal('https://test.invalid/postuler');
        ut.expect(r_offer.agency_phone).to_equal('0100000000');
        ut.expect(r_offer.agency_email).to_equal('Pour postuler : https://test.invalid/agence');
        ut.expect(r_offer.position_count).to_equal(3);
        ut.expect(r_offer.is_disability_accessible).to_be_true;
        ut.expect(r_offer.travel_code).to_equal('1');
        ut.expect(r_offer.travel_name).to_equal('Jamais');
        ut.expect(r_offer.qualification_code).to_equal('9');
        ut.expect(r_offer.qualification_name).to_equal('Cadre');
        ut.expect(r_offer.naf_code).to_equal('62.02A');
        ut.expect(r_offer.sector_code).to_equal('62');
        ut.expect(r_offer.sector_name).to_equal('Conseil en systemes informatiques');
        ut.expect(r_offer.company_size_name).to_equal('50 a 99 salaries');
        ut.expect(r_offer.offer_origin_code).to_equal('2');
        ut.expect(r_offer.offer_origin_name).to_equal('Partenaire');
        ut.expect(r_offer.offer_origin_url).to_equal('https://test.invalid/origine');
        ut.expect(r_offer.is_lacking_candidates).to_be_false;
        ut.expect(r_offer.is_adapted_employer).to_be_true;
        ut.expect(r_offer.is_disability_committed_employer).to_be_true;
    end all_fields_mapped;

    procedure missing_fields_null is
        r_offer ft_offer_search_results%rowtype;
    begin
        load('{"id": "TEST001", "intitule": "Offre minimale"}');
        select
            *
        into r_offer
        from
            ft_offer_search_results;

        ut.expect(r_offer.title).to_equal('Offre minimale');
        ut.expect(r_offer.description).to_be_null;
        ut.expect(r_offer.updated_at).to_be_null;
        ut.expect(r_offer.workplace_name).to_be_null;
        ut.expect(r_offer.company_name).to_be_null;
        ut.expect(r_offer.salary_name).to_be_null;
        ut.expect(r_offer.position_count).to_be_null;
        ut.expect(r_offer.is_work_study).to_be_null;
    end missing_fields_null;

    procedure unknown_origin_without_name is
        r_offer ft_offer_search_results%rowtype;
    begin
        load('{"id": "TEST001", "origineOffre": {"origine": "TEST"}}');
        select
            *
        into r_offer
        from
            ft_offer_search_results;

        ut.expect(r_offer.offer_origin_code).to_equal('TEST');
        ut.expect(r_offer.offer_origin_name).to_be_null;
    end unknown_origin_without_name;

    procedure api_order_kept is
        l_actual   sys_refcursor;
        l_expected sys_refcursor;
    begin
        load('{"id": "TEST002"}, {"id": "TEST003"}, {"id": "TEST001"}');
        open l_actual for select
            external_id
        from
            ft_offer_search_results
        order by
            search_rank;

        open l_expected for select
            'TEST002' as external_id
        from
            dual
        union all
        select
            'TEST003'
        from
            dual
        union all
        select
            'TEST001'
        from
            dual;

        ut.expect(l_actual).to_equal(l_expected);
    end api_order_kept;

    procedure other_collection_ignored is
        l_count pls_integer;
    begin
        load('{"id": "TEST001"}');
        apex_collection.create_or_truncate_collection('TEST_OTHER_COLLECTION');
        apex_collection.add_member(
            p_collection_name => 'TEST_OTHER_COLLECTION',
            p_c001            => 'TEST999',
            p_clob001         => '{"id": "TEST999", "intitule": "Autre collection"}'
        );

        select
            count(*)
        into l_count
        from
            ft_offer_search_results;

        ut.expect(l_count).to_equal(1);
    end other_collection_ignored;

end test_ft_offer_search_results;
/

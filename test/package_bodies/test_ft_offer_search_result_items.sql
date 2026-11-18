create or replace package body jobtracker.test_ft_offer_search_result_items is

    -- Offre fictive avec un élément dans chaque tableau de l'API, deux pour
    -- les compétences
    co_full_offer constant varchar2(4000 char) := q'[{
        "id": "TEST001",
        "competences": [
            {"code": "100001", "libelle": "Competence 1", "exigence": "E"},
            {"code": "100002", "libelle": "Competence 2", "exigence": "S"}
        ],
        "formations": [
            {"codeFormation": "31054", "domaineLibelle": "Informatique",
             "niveauLibelle": "Bac+5 et plus ou equivalents",
             "commentaire": "Commentaire formation", "exigence": "S"}
        ],
        "langues": [{"libelle": "Anglais", "exigence": "E"}],
        "permis": [{"libelle": "B - Vehicule leger", "exigence": "S"}],
        "outilsBureautiques": ["Tableur"],
        "salaire": {"listeComplements": [{"code": "14", "libelle": "Vehicule de fonction"}]},
        "qualitesProfessionnelles": [
            {"libelle": "Faire preuve de rigueur", "description": "Description qualite"}
        ],
        "origineOffre": {"partenaires": [
            {"nom": "PARTENAIRE1", "url": "https://test.invalid/offre",
             "logo": "https://test.invalid/logo.png"}
        ]},
        "contexteTravail": {"horaires": ["35H Travail le samedi"],
                            "conditionsExercice": ["Port de tenue professionnelle"]}
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

    /** Élément d'un type, à une position ; échoue s'il est absent. */
    function item (
        in_item_type     in varchar2,
        in_item_position in pls_integer default 1
    ) return ft_offer_search_result_items%rowtype is
        r_item ft_offer_search_result_items%rowtype;
    begin
        select
            *
        into r_item
        from
            ft_offer_search_result_items
        where
                item_type = in_item_type
            and item_position = in_item_position;

        return r_item;
    end item;

    procedure each_array_typed is
        l_actual   sys_refcursor;
        l_expected sys_refcursor;
    begin
        load(co_full_offer);
        open l_actual for select
            item_type,
            count(*) as item_count
        from
            ft_offer_search_result_items
        where
            external_id = 'TEST001'
        group by
            item_type
        order by
            item_type;

        open l_expected for select
            'DRIVING_LICENCE' as item_type,
            1                 as item_count
        from
            dual
        union all
        select
            'LANGUAGE',
            1
        from
            dual
        union all
        select
            'OFFICE_TOOL',
            1
        from
            dual
        union all
        select
            'PARTNER',
            1
        from
            dual
        union all
        select
            'PROFESSIONAL_QUALITY',
            1
        from
            dual
        union all
        select
            'SALARY_COMPLEMENT',
            1
        from
            dual
        union all
        select
            'SKILL',
            2
        from
            dual
        union all
        select
            'TRAINING',
            1
        from
            dual
        union all
        select
            'WORKING_CONDITION',
            1
        from
            dual
        union all
        select
            'WORKING_HOURS',
            1
        from
            dual;

        ut.expect(l_actual).to_equal(l_expected);
    end each_array_typed;

    procedure item_fields_mapped is
        r_item ft_offer_search_result_items%rowtype;
    begin
        load(co_full_offer);
        r_item := item('SKILL');
        ut.expect(r_item.item_code).to_equal('100001');
        ut.expect(r_item.item_name).to_equal('Competence 1');
        ut.expect(r_item.requirement_code).to_equal('E');
        r_item := item('TRAINING');
        ut.expect(r_item.item_code).to_equal('31054');
        ut.expect(r_item.item_name).to_equal('Informatique');
        ut.expect(r_item.item_level).to_equal('Bac+5 et plus ou equivalents');
        ut.expect(r_item.item_description).to_equal('Commentaire formation');
        ut.expect(r_item.requirement_code).to_equal('S');
        r_item := item('LANGUAGE');
        ut.expect(r_item.item_name).to_equal('Anglais');
        ut.expect(r_item.requirement_code).to_equal('E');
        r_item := item('DRIVING_LICENCE');
        ut.expect(r_item.item_name).to_equal('B - Vehicule leger');
        ut.expect(r_item.requirement_code).to_equal('S');
        ut.expect(item('OFFICE_TOOL').item_name).to_equal('Tableur');
        r_item := item('SALARY_COMPLEMENT');
        ut.expect(r_item.item_code).to_equal('14');
        ut.expect(r_item.item_name).to_equal('Vehicule de fonction');
        r_item := item('PROFESSIONAL_QUALITY');
        ut.expect(r_item.item_name).to_equal('Faire preuve de rigueur');
        ut.expect(r_item.item_description).to_equal('Description qualite');
        r_item := item('PARTNER');
        ut.expect(r_item.item_name).to_equal('PARTENAIRE1');
        ut.expect(r_item.item_url).to_equal('https://test.invalid/offre');
        ut.expect(r_item.item_logo_url).to_equal('https://test.invalid/logo.png');
        ut.expect(item('WORKING_HOURS').item_name).to_equal('35H Travail le samedi');
        ut.expect(item('WORKING_CONDITION').item_name).to_equal('Port de tenue professionnelle');
    end item_fields_mapped;

    procedure array_order_kept is
    begin
        load(co_full_offer);
        ut.expect(item('SKILL', 1).item_code).to_equal('100001');

        ut.expect(item('SKILL', 2).item_code).to_equal('100002');

    end array_order_kept;

    procedure offer_without_arrays is
        l_count pls_integer;
    begin
        load('{"id": "TEST001", "intitule": "Offre sans tableau"}');
        select
            count(*)
        into l_count
        from
            ft_offer_search_result_items;

        ut.expect(l_count).to_equal(0);
    end offer_without_arrays;

end test_ft_offer_search_result_items;
/

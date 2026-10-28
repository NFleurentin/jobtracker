create or replace package body jobtracker.test_collect_france_travail is

    procedure parse_total_reads_total is
    begin
        ut.expect(collect_france_travail.parse_total('offres 0-149/2345')).to_equal(2345);
    end parse_total_reads_total;

    procedure parse_total_without_total is
    begin
        ut.expect(collect_france_travail.parse_total('offres 0-149/')).to_be_null();
    end parse_total_without_total;

    procedure parse_total_without_header is
    begin
        ut.expect(collect_france_travail.parse_total(null)).to_be_null();
    end parse_total_without_header;

    procedure has_more_partial_content is
    begin
        ut.expect(collect_france_travail.has_more(206, 0, 3150)).to_be_true();
    end has_more_partial_content;

    procedure has_more_complete_content is
    begin
        ut.expect(collect_france_travail.has_more(200, 0, null)).to_be_false();
    end has_more_complete_content;

    procedure has_more_no_content is
    begin
        ut.expect(collect_france_travail.has_more(204, 0, null)).to_be_false();
    end has_more_no_content;

    procedure has_more_below_cap is
    begin
        ut.expect(collect_france_travail.has_more(206, 750, 3150)).to_be_true();
    end has_more_below_cap;

    procedure has_more_before_last_allowed_page is
    begin
        ut.expect(collect_france_travail.has_more(206, 2850, 3150)).to_be_true();
    end has_more_before_last_allowed_page;

    procedure has_more_at_cap is
    begin
        ut.expect(collect_france_travail.has_more(206, 3000, 3150)).to_be_false();
    end has_more_at_cap;

    procedure has_more_last_result_in_page is
    begin
        ut.expect(collect_france_travail.has_more(206, 1800, 1876)).to_be_false();
    end has_more_last_result_in_page;

    procedure has_more_total_multiple_of_page is
    begin
        ut.expect(collect_france_travail.has_more(206, 1800, 1950)).to_be_false();
    end has_more_total_multiple_of_page;

    procedure has_more_one_result_left is
    begin
        ut.expect(collect_france_travail.has_more(206, 1800, 1951)).to_be_true();
    end has_more_one_result_left;

    procedure check_page_within_cap is
    begin
        collect_france_travail.check_page(206, 3150);
        -- Aucune exception attendue
        ut.expect(true).to_be_true();
    end check_page_within_cap;

    procedure check_page_complete_without_total is
    begin
        collect_france_travail.check_page(200, null);
        ut.expect(true).to_be_true();
    end check_page_complete_without_total;

    procedure check_page_above_cap is
    begin
        collect_france_travail.check_page(206, 3151);
    end check_page_above_cap;

    procedure check_page_without_total is
    begin
        collect_france_travail.check_page(206, null);
    end check_page_without_total;

end test_collect_france_travail;
/

create or replace package body jobtracker.test_france_travail_api is

    procedure endpoint_url_offer_search is
    begin
        ut.expect(france_travail_api.endpoint_url(france_travail_api.co_endpoint_offer_search)).to_equal('https://api.francetravail.io/partenaire/offresdemploi/v2/offres/search'
        );
    end endpoint_url_offer_search;

end test_france_travail_api;
/

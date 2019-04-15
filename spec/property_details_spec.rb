require 'spec_helper'

describe UKPlanningScraper::Authority do

  describe '#include_property' do

    let(:scraper) { UKPlanningScraper::Authority.named(authority_name) }

    context 'for 2 days  with property details' do
      let(:authority_name) { 'Cardiff' }

      it 'returns apps' do
        apps = VCR.use_cassette("#{self.class.description}") {
          scraper.include_property
                 .decided_from(Date.new(2019, 4, 8))
                 .decided_to(Date.new(2019, 4, 9))
                 .scrape(delay: 0)
        }
        pp apps
      end
    end

  end

end

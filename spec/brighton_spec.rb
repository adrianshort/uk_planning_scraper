require 'spec_helper'

describe UKPlanningScraper::Authority do

  describe '#named' do

    let(:scraper) { UKPlanningScraper::Authority.named(authority_name) }

    context 'for 4 days of Brighton and Hove' do
      let(:authority_name) { 'Brighton and Hove' }

      it 'returns apps' do
        apps = VCR.use_cassette("#{self.class.description}") {
          scraper.decided_days(4).scrape({ delay: 0 })
        }
        pp apps
#        expect(authority).to be_a(UKPlanningScraper::Authority)
      end
    end

  end

end

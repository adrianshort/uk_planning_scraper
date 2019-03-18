require 'spec_helper'

describe UKPlanningScraper::Authority do
  describe 'named+council_reference scrape' do
    let(:scraper) { UKPlanningScraper::Authority.named(authority_name).council_reference(council_reference) }

    context 'for an existing idox planning reference' do
      let(:authority_name) { 'Brighton and Hove' }
      let(:council_reference) { 'BH2017/04225' }
      subject(:apps) { 
        VCR.use_cassette("#{self.class.description}") {
          scraper.scrape
        } 
      }

      it 'returns an app (in the apps array)' do
        expect(apps.any?).to be_truthy
      end

      it 'has a status of Withdrawn' do
        expect(apps.first[:status]).to eql('Withdrawn')
      end
    end

    context 'for a non-existant idox planning reference' do
      let(:authority_name) { 'Brighton and Hove' }
      let(:council_reference) { 'XYZ123' }
      subject(:apps) { 
        VCR.use_cassette("#{self.class.description}") {
          scraper.scrape
        } 
      }

      it 'returns an empty apps array' do
        expect(apps.empty?).to be_truthy
      end
    end
  end

end

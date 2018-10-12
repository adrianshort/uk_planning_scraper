require 'spec_helper'

describe UKPlanningScraper::Authority do

  describe '#named' do

    let(:authority) { described_class.named(authority_name) }

    context 'when authority exists' do
      let(:authority_name) { 'Westminster' }

      it 'returns an authority' do
        expect(authority).to be_a(UKPlanningScraper::Authority)
      end
    end

    context 'when authority does not exist' do
      let(:authority_name) { 'Westmonster' }

      it 'raises an error' do
        expect { authority }.to raise_error(UKPlanningScraper::AuthorityNotFound)
      end
    end
  end

  describe '#all' do

    let(:all) { described_class.all }

    it 'returns all authorities' do
      expect(all.count).to eq(74)
    end

    it 'returns a list of authorities' do
      all.each do |authority|
        expect(authority).to be_a(UKPlanningScraper::Authority)
      end
    end

  end

  describe '#tagged' do
    let (:tagged_london) { described_class.tagged('london') }

    it 'returns all London authorities' do
      expect(tagged_london.count).to eq(35)
    end

    let (:tagged_londonboroughs) { described_class.tagged('londonboroughs') }

    it 'returns all London boroughs' do
      expect(tagged_londonboroughs.count).to eq(32)
    end

  end

end

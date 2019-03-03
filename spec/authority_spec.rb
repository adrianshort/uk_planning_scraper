require 'spec_helper'

describe UKPlanningScraper::Authority do
  describe '#named' do
    subject(:authority) { UKPlanningScraper::Authority.named(name) }

    context 'when authority exists' do
      let(:name) { 'Westminster' }

      it 'returns an authority' do
        expect(authority).to be_a(UKPlanningScraper::Authority)
      end
    end

    context 'when authority does not exist' do
      let(:name) { 'Westmonster' }

      it 'raises an error' do
        expect { authority }.to raise_error(UKPlanningScraper::AuthorityNotFound)
      end
    end
  end

  describe '#all' do
    let(:all) { UKPlanningScraper::Authority.all }

    it 'returns more than 100 authorities' do
      expect(all.count).to be > 100
    end

    it 'returns a list of authorities' do
      all.each do |authority|
        expect(authority).to be_a(UKPlanningScraper::Authority)
      end
    end

  end

  describe '#tagged' do
    let (:authority) { UKPlanningScraper::Authority.tagged(tag) }

    context 'when tagged london' do
      let(:tag) { 'london' }

      it 'returns all 35 London authorities' do
        expect(authority.count).to eq(35)
      end
    end

    context 'when tagged londonboroughs' do
      let(:tag) { 'londonboroughs' }

      it 'returns all 32 London boroughs' do
        expect(authority.count).to eq(32)
      end
    end
  end
end

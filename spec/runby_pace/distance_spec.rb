require_relative '../spec_helper'

describe Runby::Distance do
  it 'represents a physical distance such as 5 kilometers, encapsulating a distance UOM and a multiplier' do
    # Note: UOM is short for Unit of Measure
    distance = Runby::Distance.new :km, 5
    expect(distance.to_s).to eq '5 kilometers'
  end

  describe 'distance initialization' do
    it 'defaults to 1 kilometer if no parameters are provided' do
      distance = Runby::Distance.new
      expect(distance.uom).to eq :km
      expect(distance.multiplier).to eq 1
    end

    it 'defaults to a multiplier of 1 if one is not provided' do
      distance = Runby::Distance.new(:mi)
      expect(distance.uom).to eq :mi
      expect(distance.multiplier).to eq 1
    end

    it 'parses the string as a distance if one is provided' do
      distance = Runby::Distance.new('26.2 miles')
      expect(distance.uom).to eq :mi
      expect(distance.multiplier).to eq 26.2
    end
  end

  describe '#to_s' do
    it 'pluralizes the UOM description if the multiplier is greater than 1' do
      one_km = Runby::Distance.new :km, 1
      two_km = Runby::Distance.new :km, 2
      expect(one_km.to_s).to eq '1 kilometer'
      expect(two_km.to_s).to eq '2 kilometers'
    end
  end
end

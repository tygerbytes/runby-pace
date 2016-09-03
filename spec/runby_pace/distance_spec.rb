require_relative '../spec_helper'

describe Runby::Distance do
  it 'represents a physical distance such as 5 kilometers, encapsulating a distance UOM and a multiplier' do
    # Note: UOM is short for Unit of Measure
    distance = Runby::Distance.new :km, 5
    expect(distance.to_s).to eq '5 kilometers'
  end

  describe '#meters' do
    it 'returns the total number of meters represented by the distance' do
      distance = Runby::Distance.new(:km, 10)
      expect(distance.meters).to eq 10000
    end

    it 'returns the total meters even if the units are not metric' do
      distance = Runby::Distance.new(:mi, 1)
      expect(distance.meters.round(2)).to eq 1609.34
    end
  end

  describe 'distance initialization and creation' do
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

    it 'throws a fit if the first parameter is not a string or a symbol' do
      expect { Runby::Distance.new(10, :km) }.to raise_error 'Invalid distance unit of measure'
    end

    it 'gets upset if the multiplier is not numeric' do
      expect { Runby::Distance.new(:km, 'Banana') }.to raise_error 'Invalid multiplier'
    end
  end

  describe 'Fuzzy string parsing of common distance descriptions' do
    it 'parses distances in KM such as "5K", "5km", "5 KMs" "5 kilometers"' do
      expect(Runby::Distance.new('5K').meters).to eq 5000
      expect(Runby::Distance.new('5KM').meters).to eq 5000
      expect(Runby::Distance.new('5km').meters).to eq 5000
      expect(Runby::Distance.new('5 K').meters).to eq 5000
      expect(Runby::Distance.new('5 kilometers').meters).to eq 5000
      expect(Runby::Distance.new('5 KMs').meters).to eq 5000
    end
  end

  describe '#to_s' do
    it 'pluralizes the UOM description if the multiplier is greater than 1' do
      one_km = Runby::Distance.new :km, 1
      two_km = Runby::Distance.new :km, 2
      expect(one_km.to_s).to eq '1 kilometer'
      expect(two_km.to_s).to eq '2 kilometers'
    end

    it 'does not show the decimal (e.g. "1.0") if multiplier is a round number' do
      distance = Runby::Distance.new :km, 2.0
      expect(distance.to_s).to eq '2 kilometers'
    end

    it 'shows up to 2 decimal places if the multiplier is not a whole number' do
      distance = Runby::Distance.new :km, 3.1459
      expect(distance.to_s).to eq '3.15 kilometers'
    end
  end
end

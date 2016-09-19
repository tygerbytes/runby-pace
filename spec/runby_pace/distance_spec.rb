require_relative '../spec_helper'

describe Runby::Distance do
  it 'represents a physical distance such as 5 kilometers, encapsulating a DistanceUnit and a multiplier' do
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

  describe '#kilometers' do
    it 'return the total number of kilometers represented by the distance' do
      distance = Runby::Distance.new(:mi, 3.1)
      expect(distance.kilometers).to be_within(0.1).of(5.0)
    end
  end

  describe '#convert_to UOM' do
    it 'returns a new distance converted to the given distance unit of measure' do
      distance_mi = Runby::Distance.new(:mi, 3.1)
      distance_km = distance_mi.convert_to :km
      expect(distance_km.multiplier).to be_within(0.1).of(5.0)
      expect(distance_km.uom.symbol).to eq :km
    end

    it 'converts kilometers to miles' do
      distance_mi = Runby::Distance.new(:km, 5.0)
      distance_km = distance_mi.convert_to 'miles'
      expect(distance_km.multiplier).to be_within(0.1).of(3.1)
      expect(distance_km.uom.symbol).to eq :mi
    end
  end

  describe 'distance initialization and creation' do
    it 'parses the string as a distance if one is provided' do
      distance = Runby::Distance.new('26.2 miles')
      expect(distance.uom.symbol).to eq :mi
      expect(distance.multiplier).to eq 26.2
    end

    it 'returns a clone of a Distance, if provided a Distance' do
      distance = Runby::Distance.new(:km, 5)
      clone = Runby::Distance.new(distance)
      expect(clone.to_s).to eq '5 kilometers'
    end

    it 'defaults to 1 kilometer if no parameters are provided' do
      distance = Runby::Distance.new
      expect(distance.uom.symbol).to eq :km
      expect(distance.multiplier).to eq 1
    end

    it 'defaults to a multiplier of 1 if one is not provided' do
      distance = Runby::Distance.new(:mi)
      expect(distance.uom.symbol).to eq :mi
      expect(distance.multiplier).to eq 1
    end

    it 'throws a fit if the first parameter is not a string, symbol, or Distance' do
      expect { Runby::Distance.new(10) }.to raise_error 'Invalid distance unit of measure'
    end

    it 'gets upset if the multiplier is not numeric' do
      expect { Runby::Distance.new(:km, 'Banana') }.to raise_error 'Invalid multiplier'
    end

    describe '#parse' do
      it 'parses a string as a distance and returns a new Distance' do
        distance = Runby::Distance.parse '26.2 miles'
        expect(distance.uom.symbol).to eq :mi
        expect(distance.multiplier).to eq 26.2
      end

      it 'raises an error if it cannot find something that resembles a unit of measure (UoM) in the string' do
        expect { Runby::Distance.parse '5' }.to raise_error "Unable to find distance unit in '5'"
      end

      it 'raises an error if the unit of measure is unknown to it' do
        expect { Runby::Distance.parse '15 bananas'}.to raise_error "Error parsing distance unit 'bananas'"
      end
    end

    describe '#try_parse' do
      it 'parses a string containing a valid distance and returns a results hash containing a Distance' do
        results = Runby::Distance.try_parse '5 miles'
        expect(results[:distance].uom.symbol).to eq :mi
        expect(results[:distance].multiplier).to eq 5
        expect(results[:error]).to eq nil
      end

      it 'attempts to parse a string containing an invalid distance and returns the error message in the results hash' do
        results = Runby::Distance.try_parse 'INVALID'
        expect(results[:distance]).to eq nil
        expect(results[:error]).to eq "Error parsing distance unit 'invalid'"
      end
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

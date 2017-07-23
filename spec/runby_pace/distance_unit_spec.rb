require_relative '../spec_helper'

describe Runby::DistanceUnit do
  it 'encapsulates the unit of measure for a distance, such as meters, miles, or even "1 marathon"' do
    uom = Runby::DistanceUnit.new :mi
    expect(uom.description).to eq 'mile'
  end

  it 'encapsulates the conversion factor of the unit into kilometers (E.g. Meters->KM=.001)' do
    uom = Runby::DistanceUnit.new :m
    expect(uom.conversion_factor).to eq 0.001
  end

  describe 'initialization and creation' do
    it 'is immutable' do
      uom = Runby::DistanceUnit.new('miles')
      expect(uom.frozen?).to be true
    end

    it 'can be created from a known unit of measure symbol, such as :yd' do
      uom = Runby::DistanceUnit.new :yd
      expect(uom.description).to eq 'yard'
    end

    it 'can be created from a string parseable as a known unit of measure, such as "kilometers", or "KMs"' do
      uom = Runby::DistanceUnit.new 'Kms'
      expect(uom.description).to eq 'kilometer'
    end

    it 'raises an error if initialized with a string unparseable as a unit of measure' do
      expect { Runby::DistanceUnit.new 'bananas' }.to raise_error "Error parsing distance unit 'bananas'"
    end

    it 'raises an error if initialized with a unknown unit of measure symbol' do
      expect { Runby::DistanceUnit.new :banana }.to raise_error "':banana' is an unknown unit of measure"
    end

    it 'return the same (immutable) DistanceUnit object if newing up one distance unit from another DistanceUnit' do
      distance_unit = Runby::DistanceUnit.new(:km)
      newish_distance_unit = Runby::DistanceUnit.new(distance_unit)
      expect(newish_distance_unit.object_id).to eq distance_unit.object_id
    end

    describe '#parse' do
      it 'parses a string as a distance unit of measure, and returns a new DistanceUnit' do
        uom = Runby::DistanceUnit.parse 'Marathon'
        expect(uom.description).to eq 'marathon'
      end
    end

    describe '#try_parse' do
      it 'parses a string containing a valid unit of measure and returns a results hash containing a DistanceUnit' do
        results = Runby::DistanceUnit.try_parse 'miles'
        expect(results[:uom].symbol).to eq :mi
        expect(results[:error]).to eq nil
      end

      it 'attempts to parse a string containing an invalid unit of measure and returns the error message in the results hash' do
        results = Runby::DistanceUnit.try_parse 'INVALID'
        expect(results[:uom]).to eq nil
        expect(results[:error]).to eq "Error parsing distance unit 'invalid'"
      end
    end
  end

  describe '#to_s' do
    it 'returns the UOM description if "format" is :long (default)' do
      uom = Runby::DistanceUnit.new :mi
      expect(uom.to_s(format: :long)).to eq 'mile'
    end

    it 'returns the UOM symbol as a string if "format" is :short' do
      uom = Runby::DistanceUnit.new :mi
      expect(uom.to_s(format: :short)).to eq 'mi'
    end

    it 'contains the logic for pluralizing a distance unit' do
      uom = Runby::DistanceUnit.new :mi
      expect(uom.description_plural).to eq 'miles'
      expect(uom.to_s(pluralize: true)).to eq 'miles'
    end
  end

  describe 'equality' do
    it 'considers two DistanceUnits of the same symbol to be equal' do
      uom1 = Runby::DistanceUnit.new 'Kms'
      uom2 = Runby::DistanceUnit.new 'Kms'
      expect(uom1 == uom2).to be true
    end

    it 'attempts to compare a DistanceUnit to a string parseable as a DistanceUnit' do
      uom = Runby::DistanceUnit.new 'Kms'
      expect(uom).to eq 'Kms'
    end

    it 'raises an error if unable to compare a DistanceUnit to something' do
      uom = Runby::DistanceUnit.new 'Kms'
      expect { uom == Runby::RunbyTime.new(5) }.to raise_error 'Unable to compare DistanceUnit to Runby::RunbyTime(5:00)'
    end
  end

  describe '#known_uom?' do
    it 'returns true if a symbol such as :km represents a unit of measure known to Runby Pace' do
      expect(Runby::DistanceUnit.known_uom?(:km)).to be true
    end

    it 'returns false if a given symbol is unknown to Runby Pace as a valid unit of measure' do
      expect(Runby::DistanceUnit.known_uom?(:bananas)).to be false
    end
  end
end
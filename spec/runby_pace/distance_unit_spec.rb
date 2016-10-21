require_relative '../spec_helper'

describe Runby::DistanceUnit do
  it 'encapsulates the unit of measure for a distance, such as meters, miles, or even "1 marathon"' do
    uom = Runby::DistanceUnit.new :mi
    expect(uom.description).to eq 'Mile'
  end

  it 'encapsulates the conversion factor of the unit into kilometers (E.g. Meters->KM=.001)' do
    uom = Runby::DistanceUnit.new :m
    expect(uom.conversion_factor).to eq 0.001
  end

  describe 'initialization and creation' do
    it 'can be created from a known unit of measure symbol, such as :yd' do
      uom = Runby::DistanceUnit.new :yd
      expect(uom.description).to eq 'Yards'
    end

    it 'can be created from a string parseable as a known unit of measure, such as "kilometers", or "KMs"' do
      uom = Runby::DistanceUnit.new 'Kms'
      expect(uom.description).to eq 'Kilometer'
    end

    it 'raises an error if initialized with a string unparseable as a unit of measure' do
      expect { Runby::DistanceUnit.new 'bananas' }.to raise_error "Error parsing distance unit 'bananas'"
    end

    it 'raises an error if initialized with a unknown unit of measure symbol' do
      expect { Runby::DistanceUnit.new :banana }.to raise_error "':banana' is an unknown unit of measure"
    end

    describe '#parse' do
      it 'parses a string as a distance unit of measure, and returns a new DistanceUnit' do
        uom = Runby::DistanceUnit.parse 'Marathon'
        expect(uom.description).to eq 'Marathon'
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
      expect(uom.to_s).to eq 'Mile'
    end

    it 'returns the UOM symbol as a string if "format" is :short' do
      uom = Runby::DistanceUnit.new :mi
      expect(uom.to_s(:short)).to eq 'mi'
    end
  end

  describe 'equality' do
    it 'considers two DistanceUnits of the same symbol to be equal' do
      uom1 = Runby::DistanceUnit.new 'Kms'
      uom2 = Runby::DistanceUnit.new 'Kms'
      expect(uom1 == uom2).to be true
    end
  end
end
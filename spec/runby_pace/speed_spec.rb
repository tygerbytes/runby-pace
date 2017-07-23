require_relative '../spec_helper'

describe Runby::Speed do
  it 'represents a "speed" such as 7 miles per hour' do
    speed = Runby::Speed.new('7 miles per hour')
    expect(speed).to eq '7 mi/ph'
  end

  describe 'Speed initialization' do
    it 'is immutable' do
      speed = Runby::Speed.new(7, :mi)
      expect(speed.frozen?).to be true
    end

    it 'is initialized by a distance and defaults to "per hour"' do
      distance = Runby::Distance.new(:mi, 7)
      speed = Runby::Speed.new(distance)
      expect(speed.to_s(format: :long)).to eq '7 miles per hour'
    end

    it 'is initialized by a string parseable as a Speed' do
      speed = Runby::Speed.new('10 km/ph')
      expect(speed.to_s(format: :long)).to eq '10 kilometers per hour'
    end

    it 'can be initialized by a string parseable as a Distance, which defaults to "per hour"' do
      speed = Runby::Speed.new('10 miles')
      expect(speed.to_s(format: :long)).to eq '10 miles per hour'
    end

    it 'returns the same immutable Speed object if initialized from a Speed' do
      speed = Runby::Speed.new(7, :mi)
      newish_speed = Runby::Speed.new(speed)
      expect(newish_speed.object_id).to eq speed.object_id
    end

    it 'complains if it cannot initialize the speed from the provided parameter' do
      expect { Runby::Speed.new(Runby::RunbyTime.new('5:00')) }.to raise_error 'Unable to initialize Runby::Speed from 5:00'
    end
  end

  describe 'Speed parsing' do
    it 'parses a long form speed such as "7.5 miles per hour"' do
      speed = Runby::Speed.parse '7.5 miles per hour'
      expect(speed).to eq '7.5 mi/ph'
    end

    it 'parses a short form speed such as "7.5mi/ph"' do
      speed = Runby::Speed.parse '7.5 mi/ph'
      expect(speed).to eq '7.5 mi/ph'
    end

    it '#parse raises an exception if parsing a malformed speed' do
      expect { Runby::Speed.parse('bananas per hour') }.to raise_error 'Invalid speed format (bananas per hour)'
    end

    describe '#try_parse, which returns a has containing the parsed speed, any error message, and any warning message' do
      it 'returns the parsed speed if the string was parsed successfully' do
        results = Runby::Speed.try_parse('5.5 mi/ph')
        expect(results[:speed]).to eq '5.5 miles per hour'
      end

      it 'returns a speed of nil and the error that was raised if the string is unparseable as a Speed' do
        results = Runby::Speed.try_parse('Banana')
        expect(results[:speed]).to be nil
        expect(results[:error]).to start_with 'Invalid speed format'
      end
    end
  end

  describe '#to_s' do
    it 'returns <distance> per hour if "format" is :long' do
      distance = Runby::Distance.new('9.9 miles')
      speed = Runby::Speed.new(distance)
      expect(speed.to_s(format: :long)).to eq '9.9 miles per hour'
    end

    it 'returns <distance>/ph if "format" is :short' do
      distance = Runby::Distance.new('9.9 miles')
      speed = Runby::Speed.new(distance)
      expect(speed.to_s(format: :short)).to eq '9.9 mi/ph'
    end
  end

  describe '#as_pace' do
    it 'converts the speed into a new Pace' do
      speed = Runby::Speed.new(7, :mi)
      expect(speed.as_pace).to eq '08:34'
    end
  end

  describe 'Speed comparisons' do
    it 'should be greater than another speed of lesser value' do
      speed_a = Runby::Speed.new('6 mi/ph')
      speed_b = Runby::Speed.new('1 mi/ph')
      expect(speed_a > speed_b).to be true
    end

    it 'should be greater than or equal to another speed of lesser or equal value' do
      speed_a = Runby::Speed.new('6 mi/ph')
      speed_b = Runby::Speed.new('0 mi/ph')
      speed_a_clone = Runby::Speed.new(speed_a)
      expect(speed_a >= speed_b).to be true
      expect(speed_a >= speed_a_clone).to be true
    end

    it 'should be less than another speed of greater value' do
      speed_a = Runby::Speed.new('0 mi/ph')
      speed_b = Runby::Speed.new('6 mi/ph')
      expect(speed_a < speed_b).to be true
    end

    it 'should be less than or equal to another speed of greater or equal value' do
      speed_a = Runby::Speed.new('0 mi/ph')
      speed_b = Runby::Speed.new('6 mi/ph')
      speed_a_clone = Runby::Speed.new(speed_a)
      expect(speed_a <= speed_b).to be true
      expect(speed_a <= speed_a_clone).to be true
    end

    it 'raises an error if unable to compare Speed to something' do
      speed = Runby::Speed.new(7, :mi)
      expect { speed == Runby::RunType }.to raise_error 'Unable to compare Runby::Speed to Class(Runby::RunType)'
    end
  end
end
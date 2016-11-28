require_relative '../spec_helper'

describe Runby::Speed do
  it 'represents a "speed" such as 7 miles per hour' do
    speed = Runby::Speed.new('7 miles per hour')
    expect(speed).to eq '7mi/ph'
  end

  describe 'Speed initialization' do
    it 'is initialized by a distance and defaults to "per hour"' do
      distance = Runby::Distance.new(:mi, 7)
      speed = Runby::Speed.new(distance)
      expect(speed.to_s(format: :long)).to eq '7 miles per hour'
    end

    it 'is initialized by a string parseable as a Speed or a Distance, which defaults to "per hour"' do
      speed = Runby::Speed.new('10km/ph')
      expect(speed.to_s(format: :long)).to eq '10 kilometers per hour'
    end
  end

  describe 'Speed parsing' do
    it 'parses a long form speed such as "7.5 miles per hour"' do
      speed = Runby::Speed.parse '7.5 miles per hour'
      expect(speed).to eq '7.5mi/ph'
    end

    it 'parses a short form speed such as "7.5mi/ph"' do
      speed = Runby::Speed.parse '7.5mi/ph'
      expect(speed).to eq '7.5mi/ph'
    end

    it '#parse raises an exception if parsing a malformed speed' do
      expect {Runby::Speed.parse('bananas per hour')}.to raise_error 'Invalid speed format (bananas per hour)'
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
      expect(speed.to_s(format: :short)).to eq '9.9mi/ph'
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
      speed_a = Runby::Speed.new('6mi/ph')
      speed_b = Runby::Speed.new('1mi/ph')
      expect(speed_a > speed_b).to be true
    end

    it 'should be greater than or equal to another speed of lesser or equal value' do
      speed_a = Runby::Speed.new('6mi/ph')
      speed_b = Runby::Speed.new('0mi/ph')
      speed_a_clone = Runby::Speed.new(speed_a)
      expect(speed_a >= speed_b).to be true
      expect(speed_a >= speed_a_clone).to be true
    end

    it 'should be less than another speed of greater value' do
      speed_a = Runby::Speed.new('0mi/ph')
      speed_b = Runby::Speed.new('6mi/ph')
      expect(speed_a < speed_b).to be true
    end

    it 'should be less than or equal to another speed of greater or equal value' do
      speed_a = Runby::Speed.new('0mi/ph')
      speed_b = Runby::Speed.new('6mi/ph')
      speed_a_clone = Runby::Speed.new(speed_a)
      expect(speed_a <= speed_b).to be true
      expect(speed_a <= speed_a_clone).to be true
    end
  end
end
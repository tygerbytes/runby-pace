require_relative '../spec_helper'

describe Runby::SpeedRange do
  describe 'Speed range initialization and creation' do
    it 'is immutable' do
      speed = Runby::SpeedRange.new(5, 10)
      expect(speed.frozen?).to be true
    end

    it 'creates a speed range from two decimals' do
      range = Runby::SpeedRange.new(5.371, 9.129)
      expect(range.fast).to eq '5.37 km/ph'
      expect(range.slow).to eq '9.13 km/ph'
    end

    it 'raises an error if the two values are not numeric' do
      expect { Runby::SpeedRange.new('ABC', 5.5) }.to raise_error 'Invalid fast speed value: ABC'
      expect { Runby::SpeedRange.new(5.5, 'XYZ') }.to raise_error 'Invalid slow speed value: XYZ'
    end
  end

  describe '#to_s' do
    it 'outputs a human-readable range of speed times' do
      range = Runby::SpeedRange.new(5.371, 9.129)
      expect(range.to_s(format: :short)).to eq '5.37-9.13 km/ph'
      expect(range.to_s(format: :long)).to eq '5.37-9.13 kilometers per hour'
    end

    it 'shows only one speed time when fast and slow speeds are equal' do
      range = Runby::SpeedRange.new(5.371, 5.371)
      expect(range.to_s(format: :short)).to eq '5.37 km/ph'
    end
  end

  describe '#as_pace_range' do
    it 'creates a new pace range from this speed range' do
      speed_range = Runby::SpeedRange.new(6, 5)
      pace_range = speed_range.as_pace_range
      expect(pace_range.fast).to eq '10:00'
      expect(pace_range.slow).to eq '12:00'
    end
  end
end

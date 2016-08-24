require_relative '../spec_helper'

describe Runby::RunMath do
  describe 'pace conversions' do
    it 'converts a pace-per-mile time to a mile-per-hour time (good for km too)' do
      pace = Runby::PaceTime.new('8:34')
      mph = Runby::RunMath.convert_pace_to_speed pace
      expect(mph).to eq 7
    end

    it 'converts a mile-per-hour time to a pace-per-mile time (good for km too)' do
      mph = 7
      pace = Runby::RunMath.convert_speed_to_pace mph
      expect(pace).to eq '08:34'
    end
  end

  describe 'distance calculations' do
    it 'calculates distance traveled, given a pace and a duration in seconds' do
      pace = '06:00'
      duration = '60:00'
      meters_traveled = Runby::RunMath.distance_traveled(pace, duration)
      expect(meters_traveled).to be_within(0.01).of(10)
    end
  end
end

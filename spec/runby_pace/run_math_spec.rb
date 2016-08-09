require_relative '../spec_helper'

describe RunbyPace::RunMath do
  describe 'pace conversions' do
    it 'converts a pace-per-mile time to a mile-per-hour time (good for km too)' do
      pace = RunbyPace::PaceTime.new('8:34')
      mph = RunbyPace::RunMath.convert_pace_to_speed pace
      expect(mph).to eq 7
    end

    it 'converts a mile-per-hour time to a pace-per-mile time (good for km too)' do
      mph = 7
      pace = RunbyPace::RunMath.convert_speed_to_pace mph
      expect(pace).to eq '08:34'
    end
  end
end

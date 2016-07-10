require_relative '../spec_helper'

describe RunbyPace::RunMath do
  describe 'pace conversions' do
    it 'converts a pace-per-mile time to a mile-per-hour time (good for km too)' do
      pace = RunbyPace::PaceTime.new('8:34')
      mph = RunbyPace::RunMath.convert_pace_to_speed pace
      expect(mph).to eq 7
    end
  end

end

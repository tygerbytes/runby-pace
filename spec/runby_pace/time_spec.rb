require 'spec_helper'

describe 'PaceTime' do

  describe 'PaceTime initialization' do
    it 'parses a time string such as 05:20, where 05 is the number of minutes, and 20 is the number of seconds' do
      time = RunbyPace::PaceTime.new('05:20')
      expect(time.total_seconds).to be 320
    end

    it 'expects the seconds to be between 00 and 59, inclusively' do
      expect { RunbyPace::PaceTime.new('00:60') }.to raise_error 'Seconds must be less than 60'
    end
  end
end
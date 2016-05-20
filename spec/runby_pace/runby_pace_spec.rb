require 'spec_helper'

describe RunbyPace do
  it 'has a version number' do
    expect(RunbyPace::VERSION).not_to be nil
  end

  # End to end test
  it 'tells me my ideal pace for a Long Run is 05:30-06:19, given a 5K time of 20:00' do
    long_run = RunbyPace::LongRun.new
    five_k_time = RunbyPace::PaceTime.new('20:00')
    pace_range = long_run.pace(five_k_time)
    expect(pace_range.to_s).to be '05:30-06:19'
  end
end

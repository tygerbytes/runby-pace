require_relative '../spec_helper'

describe Runby do
  it 'has a version number' do
    expect(Runby::VERSION).not_to be nil
  end

  # End to end test
  it 'tells me my ideal pace for a Long Run is 05:30-06:19, given a 5K time of 20:00' do
    long_run = Runby::RunTypes::LongRun.new
    five_k_time = Runby::RunbyTime.new('20:00')
    pace_range = long_run.lookup_pace(five_k_time)
    expect(pace_range.to_s).to eq '5:29-6:19 per kilometer'
  end
end

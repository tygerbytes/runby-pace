require_relative '../spec_helper'

describe RunbyPace::PaceData do
  it 'houses the data used to calculate the prescribed paces for a run type' do
    pace_data = RunbyPace::PaceData.new('10:00', '20:00', 2.0)
    expect(pace_data.fastest_pace_km).to eq '10:00'
    expect(pace_data.slowest_pace_km).to eq '20:00'
    expect(pace_data.midpoint_radius_divisor).to eq 2.0
  end

  it 'calculates the slope between the fastest and slowest paces' do
    pace_data = RunbyPace::PaceData.new('10:00', '66:00', 1.0)
    expect(pace_data.slope).to eq 1
  end
end
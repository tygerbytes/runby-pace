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

  it 'calculates the segment of the radius of the curve at a given X axis' do
    # Actually I'm just fudging the calculation with a simpler approach right now
    #  If we need more accuracy we'll improve the calculation in the future.
    pace_data = RunbyPace::PaceData.new('00:00', '00:00', 1.0)
    curve_offsets = [
        [0,  0],
        [1,  1],
        [14, 14],
        [28, 28],
        [42, 14],
        [55, 1],
        [56, 0],
        [57, 0],
        [99, 0]
    ]
    curve_offsets.each do |x, expected_seconds_increase|
      calculated_seconds_increase = pace_data.send('curve_minutes', x.to_i) * 60.0
      expect(calculated_seconds_increase).to eq expected_seconds_increase
    end
  end
end
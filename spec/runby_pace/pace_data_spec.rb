require_relative '../spec_helper'

describe RunbyPace::PaceData do
  it 'houses the data used to calculate the prescribed paces for a run type' do
    pace_data = RunbyPace::PaceData.new('10:00', '20:00', 2.0)
    expect(pace_data.fastest_pace_km).to eq '10:00'
    expect(pace_data.slowest_pace_km).to eq '20:00'
    expect(pace_data.midpoint_radius_divisor).to eq 2.0
  end

  it 'calculates the prescribed pace for a given 5K time' do
    pace_data = RunbyPace::PaceData.new('10:00', '20:00', 2.0)
    golden_paces = {
      '14:00': '10:00',
      '15:00': '10:22',
      '20:00': '12:14',
      '25:00': '14:06',
      '30:00': '15:54',
      '35:00': '17:37',
      '40:00': '19:19',
      '42:00': '20:00'
    }
    golden_paces.each do |five_k_time, expected_pace|
      calculated_pace = pace_data.calc(five_k_time)
      expect(calculated_pace).to eq expected_pace
    end
  end

  describe 'PaceData distance units conversions' do
    it 'calculates the pace in minutes per kilometer by default' do
      pace_data = RunbyPace::PaceData.new('10:00', '20:00', 2.0)
      expect(pace_data.calc('14:00')).to eq '10:00'
    end

    it 'calculates the pace in minutes per mile when the units are provided' do
      pace_data = RunbyPace::PaceData.new('10:00', '20:00', 2.0)
      expect(pace_data.calc('14:00', :mi)).to eq '16:07'
    end
  end

  describe 'PaceData implementation' do
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
end

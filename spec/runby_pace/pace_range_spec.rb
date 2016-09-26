require_relative '../spec_helper'

describe Runby::PaceRange do
  describe 'Pace range initialization and creation' do
    it 'creates a range from two pace time strings' do
      range = Runby::PaceRange.new('10:00', '20:00')
      expect(range.fast.time).to eq '10:00'
      expect(range.slow.time).to eq '20:00'
    end

    describe '#from_speed_range' do
      it 'Creates a new pace range from a SpeedRange' do
        speed_range = Runby::SpeedRange.new 6, 5
        pace_range = Runby::PaceRange.from_speed_range speed_range
        expect(pace_range.fast.time).to eq '10:00'
        expect(pace_range.slow.time).to eq '12:00'
      end
    end
  end

  describe '#to_s' do
    it 'outputs a human-readable range of pace times' do
      range = Runby::PaceRange.new('10:00', '10:59')
      expect(range.to_s).to eq '10:00-10:59 per kilometer'
    end

    it 'shows only one pace time when fast and slow paces are equal' do
      range = Runby::PaceRange.new('09:59', '09:59')
      expect(range.to_s).to eq '9:59 per kilometer'
    end
  end
end
